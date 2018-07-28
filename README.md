# Barracuda CloudGen Firewall for Azure - ARM templates

## Introduction

The Barracuda CloudGen Firewall (CGF) can be installed in different ways into the Microsoft Azure platform. This repository contains different methods using existing supported methods as well as methods that are in Preview on the Microsoft Azure platform. In the table below you can see which ARM Template contains which features.

![Network diagram](https://raw.githubusercontent.com/jvhoof/ngf-azure-templates/master/NGF-Quickstart-HA-1NIC-AZ-ELB-ILB-STD/images/ngf-ha-1nic-elb-ilb.png)

## Template Parameters
| Status | Name | In existing VNET | HighAvailability | ELB Basic | ELB Standard | ILB with HA Ports | Availability Zones | 1 NIC | 2 NIC
|---|---|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:
| | [NGF-Quickstart-SingleAvailability](https://github.com/jvhoof/ngf-azure-templates/tree/master/NGF-Quickstart-SingleAvailability) | - | - | x | - | - | - | - | X 
| ![Build status](https://img.shields.io/vso/build/cudajvhoof/19118fdb-7d82-4c41-a1fd-b16e490dc968/9.svg) | [NGF-Quickstart-HA-1NIC-AS-ELB-BASIC](https://github.com/jvhoof/ngf-azure-templates/tree/master/NGF-Quickstart-HA-1NIC-AS-ELB-BASIC) | - | X | X | - | - | - | - | X 
| | [NGF-Custom-SingleAvailability](https://github.com/jvhoof/ngf-azure-templates/tree/master/NGF-Custom-SingleAvailability) | X | - | X | - | - | - | - | X 
| | [NGF-Custom-HighAvailability](https://github.com/jvhoof/ngf-azure-templates/tree/master/NGF-Custom-HighAvailability) | X | X | X | - | - | - | - | X 
| ![Build status](https://img.shields.io/vso/build/cudajvhoof/19118fdb-7d82-4c41-a1fd-b16e490dc968/8.svg) | [NGF-Quickstart-HA-1NIC-AZ-ELB-ILB-STD](https://github.com/jvhoof/ngf-azure-templates/tree/master/NGF-Quickstart-HA-1NIC-AZ-ELB-ILB-STD) | - | X | - | X | X | X | X | - 
| ![Build status](https://img.shields.io/vso/build/cudajvhoof/19118fdb-7d82-4c41-a1fd-b16e490dc968/7.svg) | [NGF-Quickstart-HA-1NIC-AS-ELB-ILB-STD](https://github.com/jvhoof/ngf-azure-templates/tree/master/NGF-Quickstart-HA-1NIC-AS-ELB-ILB-STD) | - | X | - | X | X | - | X | - 
| ![Build status](https://img.shields.io/vso/build/cudajvhoof/19118fdb-7d82-4c41-a1fd-b16e490dc968/10.svg) | [NGF-Quickstart-HA-1NIC-AS-ELB-STD](https://github.com/jvhoof/ngf-azure-templates/tree/master/NGF-Quickstart-HA-1NIC-AS-ELB-STD) | - | X | - | X | - | - | X | - 
| ![Build status](https://img.shields.io/vso/build/cudajvhoof/19118fdb-7d82-4c41-a1fd-b16e490dc968/11.svg) | [NGF-Quickstart-HA-2NIC-AZ-ELB-ILB-STD](https://github.com/jvhoof/ngf-azure-templates/tree/master/NGF-Quickstart-HA-2NIC-AZ-ELB-ILB-STD) | - | X | - | X | X | X | - | X 

##### DISCLAIMER: ALL OF THE SOURCE CODE ON THIS REPOSITORY IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL BARRACUDA BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOURCE CODE. #####
