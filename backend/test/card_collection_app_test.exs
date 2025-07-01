defmodule CardCollectionAppTest do
  use ExUnit.Case, async: true

  describe "CardCollectionApp" do
    test "Tutto funziona: avanti tutta!" do
      assert Application.started?(:card_collection_app)
    end

    # altri test per funzionalità specifiche?

  end
end
