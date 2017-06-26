module GiveRide.Model exposing (Model, NewRide, init)

import Common.Response exposing (Response(..))
import Rides.Model exposing (Contact, Ride)


type alias Model =
    { fields : NewRide
    , response : Response Bool
    }


type alias NewRide =
    { name : String
    , origin : String
    , destination : String
    , days : String
    , hours : String
    , contact : Contact
    }


init : Model
init =
    { fields =
        { name = ""
        , origin = ""
        , destination = ""
        , days = ""
        , hours = ""
        , contact = { kind = "Whatsapp", value = "" }
        }
    , response = Empty
    }
