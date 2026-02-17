Loading the Library

local Lunar = loadstring(game:HttpGet("https://raw.githubusercontent.com/Someones-Scripts/LunarUILibrary/refs/heads/main/Lunar.lua"))()


Creating a Window


local window = Lunar:CreateWindow({
Title = "Lunar UI", -- this is the title

Author = "by Someones-Scripts" --this is the credits
})

Creating a Toggle

local Toggle = window:CreateToggle({
Title = "This is a Toggle!",
Callback = function(state)
print("The State is now " .. tostring(state))
end
