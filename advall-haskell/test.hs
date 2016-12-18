import qualified Data.ByteString.Char8
import qualified Crypto.Hash.MD5 as MD5
import Data.ByteString.Base16

main = print $ decode (MD5.hash (Data.ByteString.Char8.pack "apa123"))