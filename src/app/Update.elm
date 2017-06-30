module Update exposing (init, update)

import GiveRide.Update as GiveRide
import Layout.Update as Layout
import Login.Model exposing (signedInUser)
import Login.Update as Login
import Model exposing (Flags, Model, Msg(..))
import Navigation exposing (Location)
import Notifications.Update as Notifications
import Profile.Update as Profile
import Rides.Update as Rides
import UrlRouter.Model
import UrlRouter.Update as UrlRouter


init : Flags -> Location -> ( Model, Cmd.Cmd Msg )
init { currentUser, profile } location =
    let
        initialModel =
            { urlRouter = UrlRouter.init location
            , login = Login.init currentUser
            , rides = Rides.init
            , layout = Layout.init
            , giveRide = GiveRide.init
            , notifications = Notifications.init
            , profile = Profile.init profile
            }
    in
    updateUrlRouter location initialModel


update : Msg -> Model -> ( Model, Cmd.Cmd Msg )
update msg model =
    let
        urlRouter =
            UrlRouter.update model.notifications model.profile model.login msg model.urlRouter

        login =
            Login.update msg model.login

        rides =
            Rides.update msg model.rides

        layout =
            Layout.update msg model.layout

        giveRide =
            GiveRide.update (signedInUser model.login) msg model.giveRide

        notifications =
            Notifications.update msg model.notifications

        profile =
            Profile.update msg model.profile

        updatedModel =
            { urlRouter = Tuple.first urlRouter
            , login = Tuple.first login
            , rides = Tuple.first rides
            , layout = Tuple.first layout
            , giveRide = Tuple.first giveRide
            , notifications = Tuple.first notifications
            , profile = Tuple.first profile
            }

        cmds =
            Cmd.batch
                [ Cmd.map MsgForUrlRouter <| Tuple.second urlRouter
                , Cmd.map MsgForLogin <| Tuple.second login
                , Cmd.map MsgForRides <| Tuple.second rides
                , Cmd.map MsgForLayout <| Tuple.second layout
                , Cmd.map MsgForGiveRide <| Tuple.second giveRide
                , Cmd.map MsgForNotifications <| Tuple.second notifications
                , Cmd.map MsgForProfile <| Tuple.second profile
                ]
    in
    ( updatedModel, cmds )


updateUrlRouter : Location -> Model -> ( Model, Cmd.Cmd Msg )
updateUrlRouter location model =
    let
        updatedUrlRouter =
            UrlRouter.update model.notifications model.profile model.login (MsgForUrlRouter <| UrlRouter.Model.UrlChange location) model.urlRouter
    in
    ( { model | urlRouter = Tuple.first updatedUrlRouter }
    , Cmd.map MsgForUrlRouter <| Tuple.second updatedUrlRouter
    )
