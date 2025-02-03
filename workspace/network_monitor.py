#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from pysnmp.hlapi import *

def snmp_get(community, ip, oid, port=161):
    """
    通过 SNMP GET 获取单个 OID 的值。
    community: SNMP community 字符串（如 'public'）
    ip: 目标设备 IP
    oid: 要查询的 OID，如 '1.3.6.1.2.1.2.2.1.10.1' (ifInOctets 接口 1)
    port: SNMP 端口，默认 161
    """
    iterator = getCmd(
        SnmpEngine(),
        CommunityData(community, mpModel=0),  # SNMP v1/v2c
        UdpTransportTarget((ip, port)),
        ContextData(),
        ObjectType(ObjectIdentity(oid))
    )

    errorIndication, errorStatus, errorIndex, varBinds = next(iterator)

    if errorIndication:
        print(f"SNMP errorIndication: {errorIndication}")
        return None
    elif errorStatus:
        print(f"SNMP errorStatus: {errorStatus.prettyPrint()} at {errorIndex}")
        return None
    else:
        # varBinds 是一个列表, 其中每个元素是 (ObjectType(ObjectIdentity(...)), <value>)
        for varBind in varBinds:
            return varBind[1]  # 直接返回结果值
    return None

if __name__ == "__main__":
    # 举例：假设目标设备IP为 192.168.1.1，community 为 public
    # 假设要监控 ifIndex=1 的端口
    router_ip = "192.168.1.1"
    community_string = "public"
    ifIndex = 1

    # 构造 OID
    oid_in_octets  = f"1.3.6.1.2.1.2.2.1.10.{ifIndex}"  # ifInOctets
    oid_out_octets = f"1.3.6.1.2.1.2.2.1.16.{ifIndex}"  # ifOutOctets

    in_octets  = snmp_get(community_string, router_ip, oid_in_octets)
    out_octets = snmp_get(community_string, router_ip, oid_out_octets)

    print(f"Interface {ifIndex} inOctets : {in_octets}")
    print(f"Interface {ifIndex} outOctets: {out_octets}")