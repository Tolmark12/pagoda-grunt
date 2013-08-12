class ClassA
  constructor : ->
    @b = new ClassB()

window.namespace = {} # break the scope so you can interact with it
namespace.ClassA = ClassA
