AWS CLI Networking Commands
========

### 1. List All VPCs
```bash
aws ec2 describe-vpcs --query "sort_by(Vpcs, &VpcId)[*].[Tags[?Key=='Name']|[0].Value, VpcId, CidrBlock]" --output table
```
- Shows VPC IDs, CIDR blocks, and tags.

### 2. List All Subnets (sorted by VPC ID)
```bash
aws ec2 describe-subnets --query "sort_by(Subnets, &VpcId)[*].[Tags[?Key=='Name']|[0].Value, SubnetId, VpcId, CidrBlock, AvailabilityZone]" --output table
```
- Displays Subnet IDs, VPC associations, CIDR blocks, and Availability Zones.

### 3. List All Transit Gateways (TGW)
```bash
aws ec2 describe-transit-gateways --query "TransitGateways[*].[TransitGatewayId, State, OwnerId, Description]" --output table
```
- Lists TGW IDs, state, and owner details.

### 4. List All TGW Attachments
```bash
aws ec2 describe-transit-gateway-attachments --query "TransitGatewayAttachments[*].[TransitGatewayAttachmentId, TransitGatewayId, ResourceType, State, ResourceId]" --output table
```
- Shows TGW attachment IDs, resource type (VPC, DXGW, VPN, etc.), and state.

### 5. List All Route Tables
```bash
aws ec2 describe-route-tables --query "RouteTables[*].[RouteTableId, VpcId, Routes]" --output json
```
- Displays Route Table IDs, associated VPCs, and routes.

### 6. List All Security Groups
```bash
aws ec2 describe-security-groups --query "SecurityGroups[*].[GroupId, GroupName, VpcId, Description]" --output table
```
- Lists Security Group IDs, names, and VPC associations.

### 7. List Security Group Rules
```bash
aws ec2 describe-security-groups --query "SecurityGroups[*].[GroupId, IpPermissions]" --output json
```
- Shows inbound rules.
```bash
aws ec2 describe-security-groups --query "SecurityGroups[*].[GroupId, IpPermissionsEgress]" --output json
```
- Shows outbound rules.

### 8. List All VPC Peering Connections
```bash
aws ec2 describe-vpn-connections --query "VpnConnections[*].[VpnConnectionId, State, VgwTelemetry]" --output table
```
- Displays VPN connection IDs, status, and telemetry.

### 9. List All VPN Connections
```bash
aws ec2 describe-vpn-connections --query "VpnConnections[*].[VpnConnectionId, State, VgwTelemetry]" --output table
```
- Displays VPN connection IDs, status, and telemetry.

### 10. List All Direct Connect Gateways
```bash
aws directconnect describe-direct-connect-gateways --query "directConnectGateways[*].[directConnectGatewayId, directConnectGatewayName]" --output table
```
- Shows Direct Connect Gateway IDs and names.

### 11. List All AWS Network Interfaces
```bash
aws ec2 describe-network-interfaces --query "NetworkInterfaces[*].[NetworkInterfaceId, VpcId, SubnetId, PrivateIpAddress, Status]" --output table
```
- Lists ENIs, their VPCs, subnets, and IP addresses.