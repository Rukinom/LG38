--Offset baseValues outside of main logic files for clarity
baseValues = {}
local lg = love.graphics

-- THIS FUNCTION IS MEANT FOR RE-CALLING
-- DO NOT LOAD DRAWABLES! ONLY BASE VALUES
function baseValues:loadPlanets(arg)
  -- planets table
  planet = {
    sun = {
      quad = lg.newQuad(0, 0, 1024, 1024, planetsheet:getDimensions()), -- drawable crop
      scale = 0.7,
      r = 0,
      x = gameWidth+220,
      y = gameHeight-50,
      assoc_sats = {},
      gravity = 2000,
      pull = 5,
      yvel = 0,
      oy = 0
    },

    mercury = {
      quad = lg.newQuad(1025, 0, 1024, 1024, planetsheet:getDimensions()),
      scale = 0.05,
      r = 0,
      x = 1600,
      y = 900,
      assoc_sats = {},
      gravity = 0,
      pull = 0,
      selfOrbit = 0,
      yvel = -80,
      oy = 0
    },

    venus = {
      quad = lg.newQuad(2050, 0, 1024, 1024, planetsheet:getDimensions()),
      scale = 0.065,
      r = 0,
      x = 1641,
      y = 525,
      assoc_sats = {},
      gravity = 0,
      pull = 0,
      selfOrbit = 0,
      yvel = -100,
      oy = 0
    },

    earth = {
      quad = lg.newQuad(0, 1025, 1024, 1024, planetsheet:getDimensions()),
      scale = 0.078,
      r = 0,
      x = 1350,
      y = 781,
      assoc_sats = {},
      gravity = 0,
      pull = 0,
      selfOrbit = 0,
      yvel = 100,
      oy = 0
    },

    mars = {
      quad = lg.newQuad(1025, 1025, 1024, 1024, planetsheet:getDimensions()),
      scale = 0.065,
      r = 0,
      x = 1380,
      y = 461,
      assoc_sats = {},
      gravity = 0,
      pull = 0,
      selfOrbit = 0,
      yvel = -95,
      oy = 0
    },

    jupiter = {
      quad = lg.newQuad(2050, 1025, 1024, 1024, planetsheet:getDimensions()),
      scale = 0.18,
      r = 0,
      x = 965,
      y = 797,
      assoc_sats = {},
      gravity = 0,
      pull = 0,
      selfOrbit = 0,
      yvel = 80,
      oy = 0
    },

    saturn = {
      quad = lg.newQuad(0, 2050, 1024, 1024, planetsheet:getDimensions()),
      scale = 0.13,
      r = 0,
      x = 852,
      y = 380,
      assoc_sats = {},
      gravity = 0,
      pull = 0,
      selfOrbit = 0,
      yvel = -90,
      oy = 0
    },

    uranus = {
      quad = lg.newQuad(1025, 2050, 1024, 1024, planetsheet:getDimensions()),
      scale = 0.13,
      r = 0,
      x = 484,
      y = 764,
      assoc_sats = {},
      gravity = 0,
      pull = 0,
      selfOrbit = 0,
      yvel = 85,
      oy = 0
    },

    neptune = {
      quad = lg.newQuad(2050, 2050, 1024, 1024, planetsheet:getDimensions()),
      scale = 0.10,
      r = 0,
      x = 411,
      y = 318,
      assoc_sats = {},
      gravity = 0,
      pull = 0,
      selfOrbit = 0,
      yvel = 95,
      oy = 0
    },

    pluto = {
      quad = lg.newQuad(0, 3075, 1024, 1024, planetsheet:getDimensions()),
      scale = 0.03,
      r = 0,
      x = 171,
      y = 491,
      assoc_sats = {},
      gravity = 0,
      pull = 0,
      selfOrbit = 0,
      yvel = -80,
      oy = 0
    }
  }

  -- calculate and set self orbits. twice the radius at 120% or 1024%120 (scaled)
  -- done after we set everything since a table cant refference itself
  -- unlike the sun ones these are important for our satelites
  for i,object in pairs(planet) do
    if object ~= planet.sun then
      object.selfOrbit = 1024*object.scale*1.2
      object.gravity = 1024*object.scale*1.7
      object.pull = object.scale*2000
    end
  end
end

-- ENEMY BASE VALUES
function baseValues:loadEnemies(args)
  -- enemy table
  enemy = {
    normal = {
      quad = lg.newQuad(0, 0, 1024, 1024, enemysheet:getDimensions()),
      health = 1,
      damage = 1,
      speed = 100,
      scale = 0.025
    },
    medium = {
      quad = lg.newQuad(1024, 0, 1024, 1024, enemysheet:getDimensions()),
      health = 1,
      damage = 1,
      speed = 100,
      scale = 1
    },
    hard = {
      quad = lg.newQuad(0, 1024, 1024, 1024, enemysheet:getDimensions()),
      health = 1,
      damage = 1,
      speed = 100,
      scale = 1
    },
    extreme = {
      quad = lg.newQuad(1024, 1024, 1024, 1024, enemysheet:getDimensions()),
      health = 1,
      damage = 1,
      speed = 100,
      scale = 1
    }
  }
  activeEnemies = {}
end
