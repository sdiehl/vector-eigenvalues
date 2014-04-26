{-# LANGUAGE ForeignFunctionInterface #-}

module Data.Vector.Eigenvalues where

import Foreign.Ptr
import Foreign.C.Types
import Foreign.ForeignPtr

import qualified Data.Vector.Storable as V
import qualified Data.Vector.Storable.Mutable as VM

foreign import ccall safe "eigen.h eigenvalues" eigenvals
    :: Int -> Ptr a -> Ptr a -> IO Int

vecPtr :: VM.Storable a => VM.MVector s a -> ForeignPtr a
vecPtr = fst . VM.unsafeToForeignPtr0

eigvals :: Int -> V.Vector CDouble -> IO (Maybe (V.Vector CDouble))
eigvals n vs = do
  v <- V.thaw vs
  out <- VM.new 3
  rc <- withForeignPtr (vecPtr v) $ \inptr -> do
    withForeignPtr (vecPtr out) $ \outptr -> do
      eigenvals n inptr outptr
  out' <- V.freeze out

  if rc == 0 then
    return $ Just out'
  else
    return Nothing
