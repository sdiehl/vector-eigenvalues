{-# LANGUAGE ForeignFunctionInterface #-}
{-# LANGUAGE NoMonomorphismRestriction #-}

module Main where

import Data.Vector.Storable
import Data.Vector.Eigenvalues

main :: IO ()
main = do
  let mat = fromList [0..8]
  print $ eigvals 3 (mat :: Vector Double)
  print $ eigvals 3 (mat :: Vector Float)
-- Just (fromList [13.348469228349522,-1.3484692283495336,-9.991844527712246e-16])
