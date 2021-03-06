enemies = {}
local lg = love.graphics
require "fixcolor"

function enemies:load(args)
  enemysheet = lg.newImage("assets/enemysheet.png") -- load assets into memory
  explosion_particle = lg.newImage("assets/explosion_particle.png") -- load assets into memory
  baseValues:loadEnemies(args) -- call after all resources

  psystemExplode = love.graphics.newParticleSystem(explosion_particle, 99999)
	psystemExplode:setParticleLifetime(0.5, 1.5) -- Particles live at least 2s and at most 5s.
	psystemExplode:setSizeVariation(1)
  psystemExplode:setSizes(2.5, 3.5)
  psystemExplode:setLinearDamping( 0, 5 )
	psystemExplode:setLinearAcceleration(-100, -100, 100, 100) -- Random movement in all directions.
	psystemExplode:setColors(1, 1, 1, 1, 1, 1, 1, 0) -- Fade to transparency.
  psystemExplode:setSpin( 0, 10 )
end

function enemies:update(dt)

  -- iterate through both enemy and planet table and update all enemies
  for i,objEnemy in pairs(activeEnemies) do

    objEnemy.x = objEnemy.x + math.sin(math.rad(objEnemy.r))*dt*objEnemy.speed
		objEnemy.y = objEnemy.y - math.cos(math.rad(objEnemy.r))*dt*objEnemy.speed

    -- top path
    if objEnemy.path == enemyPath.top then
      self:checkPoints(enemyPath.top, objEnemy)
    --center path
    elseif objEnemy.path == enemyPath.center then
      self:checkPoints(enemyPath.center, objEnemy)
    --bottom path
    elseif objEnemy.path == enemyPath.bottom then
      self:checkPoints(enemyPath.bottom, objEnemy)
    end
    -- this path affects everyone
    self:checkPoints(enemyPath.all, objEnemy)

    if angle_utils:pointdist(objEnemy.x, objEnemy.y, planet.earth.x, planet.earth.y) <= planet.earth.gravity then
      planet.earth.health = planet.earth.health-objEnemy.damage*dt
    end

    -- change keyframe
    -- TODO CHANGE KEYFRAME BASED ON SPEED
    objEnemy.frametime = objEnemy.frametime+dt
    if objEnemy.frametime >= 100/objEnemy.speed*0.1 then
      objEnemy.frame = objEnemy.frame+1
      objEnemy.frametime = 0
    end

    -- loop around keyframes
    if objEnemy.frame > #objEnemy.quads then
      objEnemy.frame = 1
    end
  end

  -- manual iterator. Removing stuff from a normal one will cause everything to spaz. We dont want that.
  local i = 1
	while i <= #activeEnemies do
    local object = activeEnemies[i]
    --remove if offscreen. If we remove we skip iterating that frame
    if object.x > gameWidth+200 or object.x <-200 or object.y > gameHeight+200 or object.y < -200 then
      table.remove(activeEnemies, i)
    -- if health reaches 0 kill enemy and give points
    elseif object.health <= 0 then
      resources:deposit(object.score)
      psystemExplode:setPosition(object.x, object.y)
      psystemExplode:emit( 100 )
      table.remove(activeEnemies, i)
    else
      i = i+1 -- if we don't remove we iterate
    end
  end
  psystemExplode:update(dt)
end

function enemies:checkPoints(path, objEnemy)
  for n,objSwitcher in pairs(path) do
    -- go through all the path points and check if we're touching it. If yes, set our angle to the one in the point
    if angle_utils:pointdist(objEnemy.x, objEnemy.y, objSwitcher.x, objSwitcher.y) <= objSwitcher.radius then
      objEnemy.r = objSwitcher.r
    end
  end
end

function enemies:spawn(type, path)
  local newEnemy = {
    quads = type.quads,
    x = 0,
    y = 0, -- TOP 250; CENTER 590; BOTTOM 1000
    r = 0, -- TOP 110; CENTER 70; BOTTOM 50
    speed = type.speed,
    scale = type.scale,
    path = path,
    health = type.health,
    damage = type.damage,
    score = type.score,
    frame = 1,
    frametime = 0
  }
  -- change spawn locations based on height
  if path == enemyPath.top then
    newEnemy.y = 250
    newEnemy.r = 110
  elseif path == enemyPath.center then
    newEnemy.y = 590
    newEnemy.r = 70
  elseif path == enemyPath.bottom then
    newEnemy.y = 1000
    newEnemy.r = 50
  end
  -- push enemy to table
  table.insert(activeEnemies, newEnemy)
end

function enemies:draw()
  -- iterate through table and draw all enemies
  for i,object in pairs(activeEnemies) do
    lg.draw(enemysheet, object.quads[object.frame], object.x, object.y, math.rad(object.r), object.scale, object.scale, 1024/2, 1024/2)

    -- draw enemy laser
    if angle_utils:pointdist(object.x, object.y, planet.earth.x, planet.earth.y) <= planet.earth.gravity then
      lg.push("all")
      lg.setLineWidth(5)
      fixcolor:setColor(255,255,0,100)
      lg.line(object.x, object.y, planet.earth.x, planet.earth.y)
      lg.pop()
    end
  end
  lg.draw(psystemExplode, 0, 0)
end
