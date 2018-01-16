# Barracuda NextGen Firewall for Azure - ARM templates

## Introduction

The Barracuda NextGen Firewall (NGF) can be installed in different ways into the Microsoft Azure platform. This repository contains different methods using existing supported methods as well as methods that are in Preview on the Microsoft Azure platform. In the table below you can see which ARM Template contains which features.

![Network diagram](https://raw.githubusercontent.com/jvhoof/ngf-azure-templates/master/NGF-Quickstart-HA-1NIC/images/ngf-ha.png)

## Template Parameters
| Name | In existing VNET | HighAvailability | Preview | ILB with HA Ports | Availability Zones | 1 NIC | 2 NIC
|---|:---:|:---:|:---:|:---:|:---:|:---:|:---:
| [NGF-Quickstart-SingleAvailability](https://github.com/jvhoof/ngf-azure-templates/tree/master/NGF-Quickstart-HA-1NIC) | - | - | - | - | - | - | - 
| [NGF-Quickstart-HighAvailability](https://github.com/jvhoof/ngf-azure-templates/tree/master/NGF-Quickstart-HA-1NIC) | - | X | - | - | - | - | - 
| [NGF-Custom-SingleAvailability](https://github.com/jvhoof/ngf-azure-templates/tree/master/NGF-Quickstart-HA-1NIC) | X | - | - | - | - | - | - 
| [NGF-Custom-HighAvailability](https://github.com/jvhoof/ngf-azure-templates/tree/master/NGF-Quickstart-HA-1NIC) | X | X | - | - | - | - | - 
| [NGF-Quickstart-HA-1NIC](https://github.com/jvhoof/ngf-azure-templates/tree/master/NGF-Quickstart-HA-1NIC) | - | X | X | X | X | X | - 
| [NGF-Quickstart-HA-1NIC](https://github.com/jvhoof/ngf-azure-templates/tree/master/NGF-Quickstart-HA-1NIC) | - | X | X | X | X | X | - 
| [NGF-Quickstart-HA-1NIC-AS](https://github.com/jvhoof/ngf-azure-templates/tree/master/NGF-Quickstart-HA-1NIC-AS) | - | X | X | X | - | X | - 
| [NGF-Quickstart-HA-2NIC](https://github.com/jvhoof/ngf-azure-templates/tree/master/NGF-Quickstart-HA-1NIC-AS) | - | X | X | X | X | X | X 

##### DISCLAIMER: ALL OF THE SOURCE CODE ON THIS REPOSITORY IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL BARRACUDA BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOURCE CODE. #####
