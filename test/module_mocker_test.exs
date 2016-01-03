defmodule ModuleMockerTest do
  use ExUnit.Case

  defmodule MyModule.SomeModule do
    def func, do: :original_func
  end

  defmodule MyModule.Mock.SomeModule do
    def func, do: :mocked_func
  end

  test "call function from mocked module in test environment" do
    Mix.env :test

    defmodule M do
      import ModuleMocker
      mock_for_test ModuleMockerTest.MyModule.SomeModule

      def func, do: @some_module.func
    end

    assert M.func == MyModule.Mock.SomeModule.func
  end

  test "allows custom module name" do
    Mix.env :test

    defmodule N do
      import ModuleMocker
      mock_for_test ModuleMockerTest.MyModule.SomeModule, :custom_name

      def func, do: @custom_name.func
    end

    assert N.func == MyModule.Mock.SomeModule.func
  end

  test "call function from original module in development environment" do
    Mix.env :dev

    defmodule M do
      import ModuleMocker
      mock_for_test ModuleMockerTest.MyModule.SomeModule

      def func, do: @some_module.func
    end

    assert M.func == MyModule.SomeModule.func
  end

  test "call function from original module in production environment" do
    Mix.env :prod

    defmodule M do
      import ModuleMocker
      mock_for_test ModuleMockerTest.MyModule.SomeModule

      def func, do: @some_module.func
    end

    assert M.func == MyModule.SomeModule.func
  end
end
