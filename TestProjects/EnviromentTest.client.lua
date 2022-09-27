local RS = game:GetService("ReplicatedStorage")

local Vision = require(RS.Vision)

local TestProjects = script.Parent

for _, script in pairs(TestProjects:GetChildren()) do
	script.Disabled = false
end

task.wait(10)

for script, trees in pairs(Vision.Enviroments) do
	for _, tree in pairs(trees) do
		tree:unmount()
	end
end
