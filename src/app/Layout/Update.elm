module Layout.Update exposing (update)

import GiveRide.Msg exposing (Msg(..))
import Layout.Model exposing (Model)
import Layout.Msg exposing (Msg(..))
import Msg as Root exposing (Msg(..))
import Testable.Cmd


update : Root.Msg -> Model -> ( Model, Testable.Cmd.Cmd Layout.Msg.Msg )
update msg model =
    case msg of
        MsgForLayout layoutMsg ->
            ( updateLayout layoutMsg model, Testable.Cmd.none )

        MsgForGiveRide (GiveRideResponse ( Nothing, Just _ )) ->
            ( updateLayout (ShowNotification "Carona criada com sucesso!") model, Testable.Cmd.none )

        _ ->
            ( model, Testable.Cmd.none )


updateLayout : Layout.Msg.Msg -> Model -> Model
updateLayout msg model =
    case msg of
        OpenDropdown ->
            { model | dropdownOpen = True }

        CloseDropdown ->
            { model | dropdownOpen = False }

        ShowNotification notification ->
            { model | notification = Just notification }

        HideNotification ->
            model
