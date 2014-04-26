{-# LANGUAGE ForeignFunctionInterface #-}

module Main where

import Foreign.Ptr
import Foreign.C.Types
import Foreign.ForeignPtr

import qualified Data.Vector.Storable as V
import Data.Vector.Eigenvalues

mat :: V.Vector CDouble
mat = V.fromList [
     0, 1, 2,
     3, 4, 5,
     6, 7, 8
   ]

main :: IO ()
main = do
  vec <- eigvals 3 mat
  print vec
