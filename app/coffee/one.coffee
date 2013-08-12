class ClassA
  constructor  : ($el) ->
    @b = new ClassB()
    $haml = handlebars['template'] {}
    $el.append $haml

window.namespace = {} # break the scope so you can interact with it
namespace.ClassA = ClassA
