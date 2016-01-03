defmodule ModuleMocker do
  @moduledoc """
  ModuleMocker helps to mock a module during testing. ModuleMocker does not mock anything for the test,
  it just provide convention for mocking the module. ModuleMocker should be used to mock modules taht acesses
  external api or do other heavy lifting work needs to be mocked. You are responsible for defining
  the mock module and ModuleMocker will just provide easy way to use it and provide convention to define
  mock module instead of manually configuring it.
  Check this article on [Mocking](http://blog.plataformatec.com.br/2015/10/mocks-and-explicit-contracts/) to have an idea of how
  ModuleMocker can be used. We can pass second parameter to give custom name to module attribute.

  Note: ModuleMocker may not work with alias. It accepts fully qualified name of module to be mocked
  """

  @doc """
  Adds module atribute for the module passed in as argument.
  If module A.B.C is passed to the function then it will set
  module attribute '@c' to A.B.C in development and production
  and '@c' to A.B.Mock.C in test. Last part of the fully qualified name of the module will
  used as the module attribute name by default. Last part of module name would be converted to
  underscore format to create a module attribute.
  i.e) mock_for_test MyModule.SomeModule will create module attribute with name '@some_module'

  Example:

      def MyModule.MyAuth
        def func do
          IO.puts "Original function func"
        end
      end

      def MyModule.Mock.MyAuth
        def func do
          IO.puts "Mock function func"
        end
      end

      defmodule M do
        import ModuleMocker
        mock_for_test MyModule.MyAuth

        def func do
          @my_auth.func
        end
      end


  M.func will return "Original function func" in development and production and
  Will return "Mock function func" in testing environment

  Note: You have to define origin module along with mock module yourself. ModuleMocker just establishes convention.
  """
  defmacro mock_for_test({:__aliases__, _, module_path}, module_attribute \\ nil) do
    module_attribute = module_attribute || get_module_attribute_name(module_path)
    module = if Mix.env == :test do
      mock_module_name(module_path)
    else
      Module.concat module_path
    end
    quote do
      Module.put_attribute __MODULE__, unquote(module_attribute), unquote(module)
    end
  end

  defp get_module_attribute_name(module_path) do
    module_path |> List.last |> Atom.to_string |>  underscore |> String.to_atom
  end

  defp mock_module_name(module_path) do
    module_path
      |> List.insert_at(-2, :Mock)
      |> Module.concat
  end

  # Copied from https://github.com/nurugger07/inflex/blob/master/lib/inflex/underscore.ex
  defp underscore(word) when is_binary(word) do
    word
    |> String.replace(~r/([A-Z]+)([A-Z][a-z])/, "\\1_\\2")
    |> String.replace(~r/([a-z\d])([A-Z])/, "\\1_\\2")
    |> String.replace(~r/-/, "_")
    |> String.downcase
  end
end
