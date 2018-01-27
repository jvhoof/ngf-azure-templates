#Requires -Modules Pester
<#
.SYNOPSIS
    Tests a specific ARM template
.EXAMPLE
    Invoke-Pester 
.NOTES
    This file has been created as an example of using Pester to evaluate ARM templates
#>

Function random-password ($length = 15)
{
    $punc = 46..46
    $digits = 48..57
    $letters = 65..90 + 97..122

    # Thanks to
    # https://blogs.technet.com/b/heyscriptingguy/archive/2012/01/07/use-pow
    $password = get-random -count $length `
        -input ($punc + $digits + $letters) |
            % -begin { $aa = $null } `
            -process {$aa += [char]$_} `
            -end {$aa}

    return $password
}

$sourcePath = "$env:BUILD_SOURCESDIRECTORY\NGF-Quickstart-HighAvailability"
$scriptPath = "$env:BUILD_SOURCESDIRECTORY\NGF-Quickstart-HighAvailability\test"
$templateFileName = "azuredeploy.json"
$templateFileLocation = "$sourcePath\$templateFileName"
$templateMetadataFileName = "metadata.json"
$templateMetadataFileLocation = "$sourcePath\$templateMetadataFileName"
$templateParameterFileName = "azuredeploy.parameters.json"
$templateParameterFileLocation = "$sourcePath\$templateParameterFileName" 

Describe 'ARM Templates Test : Validation & Test Deployment' {
    
    Context 'Template Validation' {
        
        It 'Has a JSON template' {        
            $templateFileLocation | Should Exist
        }
        
        It 'Has a parameters file' {        
            $templateParameterFileLocation | Should Exist
        }
		
        It 'Has a metadata file' {        
            $templateMetadataFileLocation | Should Exist
        }

        It 'Converts from JSON and has the expected properties' {
            $expectedProperties = '$schema',
                                  'contentVersion',
								  'outputs',
                                  'parameters',
                                  'resources',                                
                                  'variables'
            $templateProperties = (get-content $templateFileLocation | ConvertFrom-Json -ErrorAction SilentlyContinue) | Get-Member -MemberType NoteProperty | % Name
            $templateProperties | Should Be $expectedProperties
        }
        
        It 'Creates the expected Azure resources' {
            $expectedResources = 'Microsoft.Network/networkSecurityGroups'.
                                 'Microsoft.Network/virtualNetworks',
                                 'Microsoft.Network/routeTables',
                                 'Microsoft.Network/routeTables',
                                 'Microsoft.Compute/availabilitySets',
                                 'Microsoft.Network/publicIPAddresses',
                                 'Microsoft.Network/loadBalancers',
                                 'Microsoft.Network/publicIPAddresses',
                                 'Microsoft.Network/publicIPAddresses',
                                 'Microsoft.Network/networkInterfaces',
                                 'Microsoft.Network/networkInterfaces',
                                 'Microsoft.Compute/virtualMachines',
                                 'Microsoft.Compute/virtualMachines'
            $templateResources = (get-content $templateFileLocation | ConvertFrom-Json -ErrorAction SilentlyContinue).Resources.type
            $templateResources | Should Be $expectedResources
        }
        
        It 'Contains the expected parameters' {
            $expectedTemplateParameters = 'adminPassword',
                                          'ccClusterName',
                                          'ccIpAddress',
                                          'ccManaged',
                                          'ccRangeId',
                                          'ccSecret',
                                          'imageSKU',
                                          'prefix',
                                          'subnetNGF',
                                          'subnetRed',
                                          'subnetGreen',
                                          'vmSize',
                                          'vNetAddressSpace'
            $templateParameters = (get-content $templateFileLocation | ConvertFrom-Json -ErrorAction SilentlyContinue).Parameters | Get-Member -MemberType NoteProperty | % Name
            $templateParameters | Should Be $expectedTemplateParameters
        }

    }


    Context 'Template Test Deployment' {

        # Basic Variables
        $testsRandom = Get-Random 10001
        $testsResourceGroupName = "cudaqa-ngf-quickstart-ha-1nic-as-elb-std-$testsRandom"
        $testsAdminPassword = $testsResourceGroupName | ConvertTo-SecureString -AsPlainText -Force
        $testsPrefix = "cudaqa-$testsRandom"
        $testsVM = "$testsPrefix-VM-NGF"
        $testsResourceGroupLocation = "East US"

        # List of all scripts + parameter files
        $testsTemplateList=@()
        ## dummy parameter file to test default parameters
        $testsTemplateList += ,@("azuredeploy.json","azuredeploy.parameters.json")

        # Set working directory & create resource group
        Set-Location $sourcePath
        New-AzureRmResourceGroup -Name $testsResourceGroupName -Location "$testsResourceGroupLocation"

        # Validate all ARM templates one by one
        $testsErrorFound = $false

        It "Test Deployment of ARM template $testsTemplateFile with parameter file $testsTemplateParemeterFile" {
            (Test-AzureRmResourceGroupDeployment -ResourceGroupName $testsResourceGroupName -TemplateFile "azuredeploy.json" -TemplateParameterFile "azuredeploy.parameters.json" -adminPassword $testsAdminPassword -prefix $testsPrefix).Count | Should not BeGreaterThan 0
        }
        It "Deployment of ARM template $testsTemplateFile with parameter file $testsTemplateParemeterFile" {
            $resultDeployment = New-AzureRmResourceGroupDeployment -ResourceGroupName $testsResourceGroupName -TemplateFile $templateFileLocation -TemplateParameterFile $templateParameterFileLocation -adminPassword $testsAdminPassword -prefix $testsprefix
            Write-Host ($resultDeployment | Format-Table | Out-String)
            Write-Host $resultDeployment.ProvisioningState
            $resultDeployment.ProvisioningState | Should Be "Succeeded"
        }
        It "Do we have connection with Azure?" {
            $result = Get-AzurermVM | Where-Object { $_.Name -eq $testsVM } 
            Write-Host ($result | Format-Table | Out-String)
            $result | Should Not Be $null
        }
        Remove-AzureRmResourceGroup -Name $testsResourceGroupName -Force

    }

}