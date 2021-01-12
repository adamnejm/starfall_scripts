--@name Classes and Inheritance
--@author Name
--@client

-- Please consider the following as example, not a tutorial
-- In-depth workings of things like the __index metamethod are not explained
-- Use this along other resources when learning
-- Remember that there are many ways of achieving similar system, you must choose the solution that works for you

-------------------------------------------

-- Prototype of class `Point` containing default values
-- If instance does not have one of those keys defined, it will look here
local Point = { name = "Point", x = 0, y = 0 }

-- When asked for keys undefined in the instance itself, make it use the `Point` table
-- This will enable instance to both access methods like `Point:getX()` and the keys defined in the prototype above
Point.__index = Point

-- Constructor that will be used to create new instances
function Point:new(x, y)
	-- At this point the `self` keyword is not referring to instance, so we create a new table that will become the instance
	local instance = {
		x = x,
		y = y,
	}
	
	-- Enable the metaevents from `Point` like `__index` to work on this table,
	-- thus making it an actual instance of the `Point` class
	return setmetatable(instance, Point)
end

-- Here we finally can start customizing the methods that we'll be executing on instances of the class `Point`
-- This is also the place where you can start referring your instance as `self`,
-- obviously as long as the methods defined use `:` instead of `.`

-- This is the simplest metaevent, it's executed when doing `tostring(object)` and is expected to return a string,
-- usually a nice name for your instance
function Point:__tostring()
	return string.format("[%s] X:%d Y:%d", self.name, self.x, self.y)
end

-- Asks user for input and sets that within the instance itself
function Point:setX(x)
	self.x = x
end

-- This is simple, but you need to keep in mind that we defined `x` in our prototype
-- Because of that, when instance does not have `x` defined (`x` is `nil`),
-- it will return value from the `Point` table
function Point:getX()
	return self.x
end

-------------------------------------------

-- Now lets create subclass that will inherit from the `Point` base class

-- Like before, a prototype, but this time if key is not found here, it will use `Point` prototype
-- You can obviously override the keys if you wish so, here the `name` is overridden
local Rectangle = { name = "Rectangle", w = 0, h = 0 }

-- Just like we did for `Point`, we make instance of this class look in the `Rectangle` table in case of an undefined key
Rectangle.__index = Rectangle

-- This is where the magic of inheritance happens, when key is not found, make it look in the `Point` class
-- So when requesting key on an instance it will look in those places respectively:
-- 1. itself; 2. `Rectangle` table; 3. `Point` table
setmetatable(Rectangle, { __index = Point })

-- Just like before we need a constructor
-- We actually already inherited this function from the `Point` class,so this is actually an override
-- Let's take both arguments we had in `Point`: `x` and `y`, plus some new arguments for this specific class
function Rectangle:new(x, y, w, h)
	-- Creating instance of this class can be done just like before, by making a new table
	-- But it's often nice (especially in case of long or complex constructors) to use what we already wrote
	-- by creating an instance of the parent class, modifying it and overriding it's metatable (last line in this scope)
	local instance = Point:new(x, y)
	
	-- Adding new keys specific to this class
	instance.w = w
	instance.h = h
	
	-- Like before, but in this case the metatable will be overriden to point to `Rectangle` table
	return setmetatable(instance, Rectangle)
end

function Rectangle:__tostring()
	return string.format("[%s] X:%d Y:%d W:%d H:%d", self.name, self.x, self.y, self.w, self.h)
end

function Rectangle:setW(w)
	self.w = w
end

function Rectangle:getW()
	return self.w
end

-------------------------------------------

local p = Point:new(1, 2)
print(p) --> [Point] X:1 Y:2
p:setX(123)
print(p:getX()) --> 123

local r = Rectangle:new(nil, 111)
print(r:getX()) --> 0 (from the `Point` prototype)
r:setX(777)
r:setW(999)
print(r) --> [Rectangle] X:777 Y:0 W:999 H:0

