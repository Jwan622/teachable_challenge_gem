## Some design choices

I think the design of this gem was heavily influenced by these links:
[configuration module](https://viget.com/extend/easy-gem-configuration-variables-with-defaults)

I include the Configuration model for the times when the user's configuration changes at runtime.

I wrote the method signatures with keyword arguments because I'm all about that life (it sincerity, it does 3 things for us:
  1. allows us to see what the names of the arguments are without having to read the method of the body.
  2. reduces boiletplate code for extracting hash options.
  3. The caling method is syntactically equal to calling a method with hash options.)
