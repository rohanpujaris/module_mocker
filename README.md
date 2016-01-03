# ModuleMocker

ModuleMocker helps to mock a module during testing. ModuleMocker does not mock anything for the test, it just provide convention for mocking the module. ModuleMocker should be used to mock modules taht acesses external api or do other heavy lifting work needs to be mocked. You are responsible for defining the mock module and ModuleMocker will just provide easy way to use it and provide convention to define mock module instead of manually configuring it. Check this article on [Mocking](http://blog.plataformatec.com.br/2015/10/mocks-and-explicit-contracts/) to have an idea of how ModuleMocker can be used.

Example:

```
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
    # will call MyModule.MyAuth.func in development and production environment
    # will call MyModule.Mock.MyAuth.func in test environment
    @my_auth.func
  end
end
```
