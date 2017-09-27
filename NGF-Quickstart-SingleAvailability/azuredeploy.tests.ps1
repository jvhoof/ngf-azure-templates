Describe "Check deployment" {
    It "has deployed TestVM" {
        Get-AzurermVM | Where-Object { $_.Name -eq "CUDA-VM-NGF" }  | Should Not Be $null
    }
    It "has removed TestVM3" {
        Get-AzurermVM | Where-Object { $_.Name -eq "TestVM3" }  | Should Be $null
    }
    It "TestVM is Size DS1_V2" {
        Get-AzurermVM | Where-Object { $_.Name -eq "CUDA-VM-NGF" } | Where-Object { $_.HardwareProfile.VmSize -eq "Standard_DS1_v2" } | Should Not Be $null
    }
}