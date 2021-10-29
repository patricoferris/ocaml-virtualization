#include <Virtualization/Virtualization.h>
#include <caml/memory.h>
#include <caml/mlvalues.h>

// Network Configuration

// MAC Address

VZMACAddress *caml_macaddress(void)
{
  VZMACAddress *mac = [[VZMACAddress alloc] init];
  return mac;
}

// Network Device Configuration

VZNetworkDeviceConfiguration *caml_network_configuration(void)
{
  VZNetworkDeviceConfiguration *conf = [[VZNetworkDeviceConfiguration alloc] init];
  return conf;
}


void caml_network_set_macaddress(VZMACAddress *macaddr, VZNetworkDeviceConfiguration *conf)
{
  [conf setMACAddress:macaddr];
  return;
}

// Serial Port Configuration
VZSerialPortConfiguration *caml_serial_configuration(void)
{
  VZSerialPortConfiguration *conf = [[VZSerialPortConfiguration alloc] init];
  return conf;
}


VZVirtioConsoleDeviceSerialPortConfiguration *caml_virtio_serial_configuration(void)
{
  VZVirtioConsoleDeviceSerialPortConfiguration *conf = [[VZVirtioConsoleDeviceSerialPortConfiguration alloc] init];
  return conf;
}

// VM Configuration

VZVirtualMachineConfiguration *caml_vm_configuration(void)
{
  VZVirtualMachineConfiguration *conf = [[VZVirtualMachineConfiguration alloc] init];
  return conf;
}

CAMLprim value caml_vm_set_cpu_count(value val_cpu_count, VZVirtualMachineConfiguration *conf)
{
  CAMLparam1(val_cpu_count);
  int cpus = Val_int(val_cpu_count);
  [conf setCPUCount:cpus];
  CAMLreturn(Val_unit);
}

// Note: This function assumes the memory size is a multiple of a megabyte
CAMLprim value caml_vm_set_memory_size(value val_memory_size, VZVirtualMachineConfiguration *conf)
{
  CAMLparam1(val_memory_size);
  int ms = Val_int(val_memory_size);
  [conf setMemorySize:ms];
  CAMLreturn(Val_unit);
}


