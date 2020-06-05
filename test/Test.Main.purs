module Test.Main (main) where

import Prelude
import Data.Maybe as Data.Maybe
import Effect as Effect
import Effect.Aff as Effect.Aff
import Option as Option
import Test.Spec as Test.Spec
import Test.Spec.Assertions as Test.Spec.Assert
import Test.Spec.Reporter.Console as Test.Spec.Reporter.Console
import Test.Spec.Runner as Test.Spec.Runner

data Proxy (symbol :: Symbol)
  = Proxy

main :: Effect.Effect Unit
main = Effect.Aff.launchAff_ (Test.Spec.Runner.runSpec reporters spec)

reporters :: Array Test.Spec.Runner.Reporter
reporters =
  [ Test.Spec.Reporter.Console.consoleReporter
  ]

spec :: Test.Spec.Spec Unit
spec = do
  Test.Spec.describe "Option" do
    Test.Spec.describe "set" do
      Test.Spec.it "sets a value when it doesn't exist" do
        let
          someOption :: Option.Option ( foo :: Boolean, bar :: Int )
          someOption = Option.empty

          anotherOption :: Option.Option ( foo :: Boolean, bar :: Int )
          anotherOption = Option.set (Proxy :: _ "bar") 31 someOption
        Option.get (Proxy :: _ "bar") anotherOption `Test.Spec.Assert.shouldEqual` Data.Maybe.Just 31
    Test.Spec.describe "set'" do
      Test.Spec.it "sets a value when it doesn't exist" do
        let
          someOption :: Option.Option ( foo :: Boolean, bar :: Int )
          someOption = Option.empty

          anotherOption :: Option.Option ( foo :: Boolean, bar :: Int )
          anotherOption = Option.set' { bar: 31 } someOption
        Option.get (Proxy :: _ "bar") anotherOption `Test.Spec.Assert.shouldEqual` Data.Maybe.Just 31
      Test.Spec.it "can change the type" do
        let
          someOption :: Option.Option ( foo :: Boolean, bar :: Boolean )
          someOption = Option.empty

          anotherOption :: Option.Option ( foo :: Boolean, bar :: Int )
          anotherOption = Option.set' { bar: 31 } someOption
        Option.get (Proxy :: _ "bar") anotherOption `Test.Spec.Assert.shouldEqual` Data.Maybe.Just 31
      Test.Spec.it "can use a `Data.Maybe.Maybe _`" do
        let
          someOption :: Option.Option ( foo :: Boolean, bar :: Int )
          someOption = Option.empty

          anotherOption :: Option.Option ( foo :: Boolean, bar :: Int )
          anotherOption = Option.set' { bar: Data.Maybe.Just 31 } someOption
        Option.get (Proxy :: _ "bar") anotherOption `Test.Spec.Assert.shouldEqual` Data.Maybe.Just 31
      Test.Spec.it "`Data.Maybe.Nothing` keeps the previous value" do
        let
          someOption :: Option.Option ( foo :: Boolean, bar :: Int )
          someOption = Option.fromRecord { bar: 31 }

          anotherOption :: Option.Option ( foo :: Boolean, bar :: Int )
          anotherOption = Option.set' { bar: Data.Maybe.Nothing } someOption
        Option.get (Proxy :: _ "bar") anotherOption `Test.Spec.Assert.shouldEqual` Data.Maybe.Just 31

    Test.Spec.describe "fromOption" do
      Test.Spec.it "provides default value if it doesn't exist" do
        let
          someOption :: Option.Option ( foo :: Boolean, bar :: Int )
          someOption = Option.fromRecord { foo: true }

          defaults :: { bar :: Int }
          defaults = { bar: 0 }

          expected :: { bar :: Int }
          expected = defaults

          actual :: { bar :: Int }
          actual = Option.fromOption someOption defaults

        actual `Test.Spec.Assert.shouldEqual` expected

      Test.Spec.it "uses original value if it exists" do
        let
          original :: { foo :: Boolean }
          original = { foo: true }

          someOption :: Option.Option ( foo :: Boolean, bar :: Int )
          someOption = Option.fromRecord original

          defaults :: { foo :: Boolean }
          defaults = { foo: false }

          expected :: { foo :: Boolean }
          expected = original

          actual :: { foo :: Boolean }
          actual = Option.fromOption someOption defaults

        actual `Test.Spec.Assert.shouldEqual` expected
