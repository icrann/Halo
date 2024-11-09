local CollectionService = game:GetService("CollectionService")

local Halo = {}

Halo.Version = 24.0

local haloInstances = CollectionService:GetTagged("halo")

local function findHaloInstanceByName (nameValue)
	local haloInstances = CollectionService:GetTagged("halo")
	for index, instance in ipairs(haloInstances) do
		if instance:GetAttribute("_name") == nameValue then
			return instance
		end
	end
	return nil
end

local function propertyTypeConversion (value)
	if value == "true" then
		return true
	elseif value == "false" then
		return false
	elseif tonumber(value) then
		return tonumber(value)
	else
		return value
	end
end


for index, instance in ipairs(haloInstances) do
	if (instance:GetAttribute("_click")) then
		local clickDetector = Instance.new("ClickDetector", instance)
		
		clickDetector.MouseClick:Connect(function(player)
			local name, property, value = string.match(instance:GetAttribute("_click"), "^(%w+)%.(%w+)=([%w%d]+)$")
			
			local targetInstance = findHaloInstanceByName(name)
			local propertyType = propertyTypeConversion(value)
			
			if (propertyType == "cycleBool")  then
				if (targetInstance[property] == true) then
					targetInstance[property] = false
				elseif (targetInstance[property] == false) then
					targetInstance[property] = true
				else
					error("Halo: cycleBool can only be used on Boolean properties on instance: " + instance)
				end
			else
				targetInstance[property] = propertyType
			end
		end)
	end
	
	if (instance:GetAttribute("_touch")) then
		instance.Touched:Connect(function(hitPart)
			if not instance:GetAttribute("Debounce") then
				instance:SetAttribute("Debounce", true)
				
				local name, property, value = string.match(instance:GetAttribute("_touch"), "^(%w+)%.(%w+)=([%w%d]+)$")

				local targetInstance = findHaloInstanceByName(name)
				local propertyType = propertyTypeConversion(value)

				if (propertyType == "cycleBool")  then
					if (targetInstance[property] == true) then
						targetInstance[property] = false
					elseif (targetInstance[property] == false) then
						targetInstance[property] = true
					else
						error("Halo: cycleBool can only be used on Boolean properties on instance: " + instance)
					end
				else
					targetInstance[property] = propertyType
				end
				
				task.wait(1)
				instance:SetAttribute("Debounce", false)
			end
		end)
	end
	
	if (instance:GetAttribute("_playerTouch")) then
		instance.Touched:Connect(function(hitPart)
			
			local humanoid = hitPart.Parent:FindFirstChildWhichIsA("Humanoid")
			
			if humanoid then
				if not instance:GetAttribute("Debounce") then
					instance:SetAttribute("Debounce", true)

					local name, property, value = string.match(instance:GetAttribute("_playerTouch"), "^(%w+)%.(%w+)=([%w%d]+)$")

					local targetInstance = findHaloInstanceByName(name)
					local propertyType = propertyTypeConversion(value)

					if (propertyType == "cycleBool")  then
						if (targetInstance[property] == true) then
							targetInstance[property] = false
						elseif (targetInstance[property] == false) then
							targetInstance[property] = true
						else
							error("Halo: cycleBool can only be used on Boolean properties on instance: " + instance)
						end
					else
						targetInstance[property] = propertyType
					end

					task.wait(1)
					instance:SetAttribute("Debounce", false)
				end
			end
		end)
	end
end

return Halo
