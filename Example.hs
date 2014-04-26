{-# LANGUAGE ForeignFunctionInterface #-}

module Main where

import Foreign.C.Types
import Data.Vector.Storable
import Data.Vector.Eigenvalues

mat :: Vector Double
mat = fromList [
     0, 1, 2,
     3, 4, 5,
     6, 7, 8
   ]

main :: IO ()
main = do
  eigs <- eigvals 3 mat
  print eigs
-- Just (fromList [13.348469228349522,-1.3484692283495336,-9.991844527712246e-16])
