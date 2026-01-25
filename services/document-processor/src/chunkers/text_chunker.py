"""
Text Chunkers
Split documents into smaller chunks for embedding and retrieval
"""

from typing import List, Dict, Any, Optional
from abc import ABC, abstractmethod
import re


class Chunk:
    """Represents a chunk of text from a document"""
    
    def __init__(
        self,
        content: str,
        index: int,
        char_start: int,
        char_end: int,
        metadata: Optional[Dict[str, Any]] = None
    ):
        self.content = content
        self.index = index
        self.char_start = char_start
        self.char_end = char_end
        self.metadata = metadata or {}
    
    def to_dict(self) -> Dict[str, Any]:
        return {
            "content": self.content,
            "index": self.index,
            "char_start": self.char_start,
            "char_end": self.char_end,
            "metadata": self.metadata
        }


class BaseChunker(ABC):
    """Base class for text chunkers"""
    
    @abstractmethod
    def chunk(self, text: str, metadata: Optional[Dict[str, Any]] = None) -> List[Chunk]:
        """Split text into chunks"""
        pass


class RecursiveCharacterChunker(BaseChunker):
    """
    Recursive character-based text splitter
    Tries to split on natural boundaries (paragraphs, sentences, words)
    """
    
    def __init__(
        self,
        chunk_size: int = 1000,
        chunk_overlap: int = 200,
        separators: Optional[List[str]] = None
    ):
        self.chunk_size = chunk_size
        self.chunk_overlap = chunk_overlap
        self.separators = separators or [
            "\n\n",  # Paragraphs
            "\n",    # Lines
            ". ",    # Sentences
            "? ",
            "! ",
            "; ",
            ", ",
            " ",     # Words
            ""       # Characters
        ]
    
    def _split_text(self, text: str, separators: List[str]) -> List[str]:
        """Recursively split text using separators"""
        final_chunks = []
        
        # Find the first separator that exists in the text
        separator = separators[-1]  # Default to last (smallest) separator
        new_separators = []
        
        for i, sep in enumerate(separators):
            if sep == "":
                separator = sep
                break
            if sep in text:
                separator = sep
                new_separators = separators[i + 1:]
                break
        
        # Split on the separator
        splits = text.split(separator) if separator else list(text)
        
        # Process each split
        good_splits = []
        for split in splits:
            if len(split) < self.chunk_size:
                good_splits.append(split)
            elif new_separators:
                # Recursively split if too large
                final_chunks.extend(self._split_text(split, new_separators))
            else:
                # Can't split further, add as is
                good_splits.append(split)
        
        # Merge small splits back together
        if good_splits:
            merged = self._merge_splits(good_splits, separator)
            final_chunks.extend(merged)
        
        return final_chunks
    
    def _merge_splits(self, splits: List[str], separator: str) -> List[str]:
        """Merge small splits into chunks of appropriate size"""
        merged = []
        current_chunk = []
        current_length = 0
        
        for split in splits:
            split_length = len(split)
            
            if current_length + split_length + len(separator) > self.chunk_size:
                if current_chunk:
                    merged.append(separator.join(current_chunk))
                current_chunk = [split]
                current_length = split_length
            else:
                current_chunk.append(split)
                current_length += split_length + len(separator)
        
        if current_chunk:
            merged.append(separator.join(current_chunk))
        
        return merged
    
    def chunk(self, text: str, metadata: Optional[Dict[str, Any]] = None) -> List[Chunk]:
        """Split text into overlapping chunks"""
        if not text or not text.strip():
            return []
        
        # Get initial splits
        splits = self._split_text(text, self.separators)
        
        # Create chunks with overlap
        chunks = []
        char_position = 0
        
        for i, split in enumerate(splits):
            # Find actual position in original text
            start_pos = text.find(split, char_position)
            if start_pos == -1:
                start_pos = char_position
            end_pos = start_pos + len(split)
            
            chunk = Chunk(
                content=split.strip(),
                index=i,
                char_start=start_pos,
                char_end=end_pos,
                metadata=metadata.copy() if metadata else {}
            )
            chunks.append(chunk)
            
            # Update position (accounting for some overlap)
            char_position = max(char_position, end_pos - self.chunk_overlap)
        
        return chunks


class SentenceChunker(BaseChunker):
    """Split text by sentences, grouping into chunks"""
    
    def __init__(
        self,
        chunk_size: int = 1000,
        chunk_overlap: int = 1,  # Number of sentences to overlap
    ):
        self.chunk_size = chunk_size
        self.chunk_overlap = chunk_overlap
        # Sentence boundary pattern
        self.sentence_pattern = re.compile(r'(?<=[.!?])\s+(?=[A-Z])')
    
    def chunk(self, text: str, metadata: Optional[Dict[str, Any]] = None) -> List[Chunk]:
        if not text or not text.strip():
            return []
        
        # Split into sentences
        sentences = self.sentence_pattern.split(text)
        sentences = [s.strip() for s in sentences if s.strip()]
        
        chunks = []
        current_sentences = []
        current_length = 0
        char_position = 0
        
        for sentence in sentences:
            sentence_length = len(sentence)
            
            if current_length + sentence_length > self.chunk_size and current_sentences:
                # Create chunk from current sentences
                chunk_text = " ".join(current_sentences)
                start_pos = text.find(current_sentences[0], char_position)
                if start_pos == -1:
                    start_pos = char_position
                
                chunk = Chunk(
                    content=chunk_text,
                    index=len(chunks),
                    char_start=start_pos,
                    char_end=start_pos + len(chunk_text),
                    metadata=metadata.copy() if metadata else {}
                )
                chunks.append(chunk)
                
                # Keep overlap sentences
                overlap_count = min(self.chunk_overlap, len(current_sentences))
                current_sentences = current_sentences[-overlap_count:]
                current_length = sum(len(s) for s in current_sentences)
                char_position = start_pos + len(chunk_text) - current_length
            
            current_sentences.append(sentence)
            current_length += sentence_length
        
        # Add remaining sentences
        if current_sentences:
            chunk_text = " ".join(current_sentences)
            start_pos = text.find(current_sentences[0], char_position)
            if start_pos == -1:
                start_pos = char_position
            
            chunk = Chunk(
                content=chunk_text,
                index=len(chunks),
                char_start=start_pos,
                char_end=start_pos + len(chunk_text),
                metadata=metadata.copy() if metadata else {}
            )
            chunks.append(chunk)
        
        return chunks


def get_chunker(
    strategy: str = "recursive",
    chunk_size: int = 1000,
    chunk_overlap: int = 200
) -> BaseChunker:
    """Factory function to get chunker by strategy"""
    if strategy == "recursive":
        return RecursiveCharacterChunker(chunk_size=chunk_size, chunk_overlap=chunk_overlap)
    elif strategy == "sentence":
        return SentenceChunker(chunk_size=chunk_size, chunk_overlap=1)
    else:
        raise ValueError(f"Unknown chunking strategy: {strategy}")
