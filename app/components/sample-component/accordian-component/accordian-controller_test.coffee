# Tests are anything of the form *_test.coffee to the build, and they can be
# nested anywhere in your folder/component structure.

# Note: These leverage jasmine-given by @searls

describe "AccordianController", () ->
  it "to work correctly", () ->
    a = 12
    b = a

    expect(a).toBe(b)
    expect(a).not.toBe(null)

describe "assigning stuff to this", ->
  Given -> @number = 24
  Given -> @number++
  When -> @number *= 2
  Then -> @number == 50
  # or
  Then -> expect(@number).toBe(50)

describe "assigning stuff to variables", ->
  subject=null
  Given -> subject = []
  When -> subject.push('foo')
  Then -> subject.length == 1
  # or
  Then -> expect(subject.length).toBe(1)