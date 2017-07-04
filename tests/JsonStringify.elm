module JsonStringify exposing (simpleStringify)

import Json.Decode
import Json.Encode
import List.Extra
import Regex exposing (HowMany(..), regex, replace)


simpleStringify : a -> Json.Encode.Value
simpleStringify a =
    toString a
        |> replace All (regex " ([^ ]+) =") (\match -> " \"" ++ matchOrEmptyAt match 1 ++ "\":")
        |> Json.Decode.decodeString Json.Decode.value
        |> unwrap


matchOrEmptyAt : Regex.Match -> Int -> String
matchOrEmptyAt match index =
    match.submatches
        |> List.Extra.getAt (index - 1)
        |> Maybe.withDefault Nothing
        |> Maybe.withDefault ""


unwrap : Result a b -> b
unwrap result =
    case result of
        Ok res ->
            res

        Err err ->
            Debug.crash (toString err)
