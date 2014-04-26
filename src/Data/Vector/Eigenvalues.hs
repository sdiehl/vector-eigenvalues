{-# LANGUAGE ForeignFunctionInterface #-}
{-# LANGUAGE FlexibleInstances #-}

module Data.Vector.Eigenvalues (
  eigvals
) where

import Foreign.Ptr
import Foreign.ForeignPtr (withForeignPtr, ForeignPtr)

import Control.Monad.ST.Strict (runST)
import Control.Monad.ST.Unsafe (unsafeIOToST)

import qualified Data.Vector.Storable as V
import qualified Data.Vector.Storable.Mutable as VM

foreign import ccall safe "eigen.h eigen_float" eigen_float
    :: Int -> Ptr Float -> Ptr Float -> Int

foreign import ccall safe "eigen.h eigen_double" eigen_double
    :: Int -> Ptr Double -> Ptr Double -> Int


class Eigenvalues a where
  eigvals :: Int -> a -> Maybe a

instance Eigenvalues (V.Vector Float) where
  eigvals = eigen_worker eigen_float

instance Eigenvalues (V.Vector Double) where
  eigvals = eigen_worker eigen_double


{-# NOINLINE vecPtr #-}
vecPtr :: VM.Storable a => VM.MVector s a -> ForeignPtr a
vecPtr = fst . VM.unsafeToForeignPtr0

eigen_worker :: VM.Storable a
             => (Int -> Ptr a -> Ptr a -> Int) -- worker function
             -> Int                            -- dimension
             -> V.Vector a                     -- input vector
             -> Maybe (V.Vector a)             -- output
eigen_worker fn n vs |
  (V.length vs == n * n) = runST $ do
    inp <- V.thaw vs
    out <- VM.new n

    rc <- unsafeIOToST $
      withForeignPtr (vecPtr inp) $ \inptr -> do
        withForeignPtr (vecPtr out) $ \outptr -> do
          return $! fn n inptr outptr

    out' <- V.freeze out
    if rc == 0
      then return $ Just out'
      else return Nothing
eigen_worker _ _ _ = error "dimensions are invalid"
