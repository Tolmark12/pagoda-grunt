class ClassA
  constructor  : ($el) ->
    @b = new ClassB()
    $haml = handlebars['template'] {val : "words"}
    $el.append $haml

window.namespace = {} # break the scope like this
namespace.ClassA = ClassA
