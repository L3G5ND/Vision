local RS = game:GetService("ReplicatedStorage")

local TestEZ = require(RS.Packages.TestEZ)

local results = TestEZ.TestBootstrap:run(
	{RS.Vision}
)

local ranSuccessfully = (results.failureCount == 0 and #results.errors == 0) and true or false

if ranSuccessfully then
    print('[TestEZ] - .spec files ran successfully')
else
    print('[TestEZ] - .spec files ran unsucessfully')
end