function onCreate()
    makeLuaSprite('solidBG', '', -500, -1000)
	makeGraphic('solidBG', 2400, 2000, '23062D')
	setScrollFactor('solidBG', 0.2, 0.2)
	addLuaSprite('solidBG')

    makeLuaSprite('mallEvilBG', 'christmas/evilBG', -400, -500)
    scaleObject('mallEvilBG', 0.8, 0.8)
    setScrollFactor('mallEvilBG', 0.2, 0.2)
	addLuaSprite('mallEvilBG')

    makeLuaSprite('christmasTreeEvil', 'christmas/evilTree', 300, -300)
    setScrollFactor('christmasTreeEvil', 0.2, 0.2)
	addLuaSprite('christmasTreeEvil')

    makeLuaSprite('snowEvilGround', 'christmas/evilSnow', -500, 700)
    addLuaSprite('snowEvilGround')
end