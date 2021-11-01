#include <Virtualization/Virtualization.h>
#include <caml/alloc.h>
#include <caml/custom.h>
#include <caml/memory.h>
#include <caml/mlvalues.h>
#define Bootloader_val(v) (*((VZLinuxBootLoader **)Data_custom_val(v)))

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

CAMLprim value caml_set_serial_port_attachment(value val_read, value val_write, VZVirtioConsoleDeviceSerialPortConfiguration *conf)
{
  CAMLparam2(val_read, val_write);
  int read = Val_int(val_read);
  int write = Val_int(val_write);
  NSFileHandle *in = [[NSFileHandle alloc] initWithFileDescriptor:read];
  NSFileHandle *out = [[NSFileHandle alloc] initWithFileDescriptor:write];
  VZSerialPortAttachment *pa = [[VZSerialPortAttachment alloc] initWithFileHandleForReading:in fileHandleForWriting:out];
  [conf setAttachment:pa];
  CAMLreturn(Val_unit);
}

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

CAMLprim value caml_vm_set_bootloader(value val_bootloader, VZVirtualMachineConfiguration *conf)
{
  CAMLparam1(val_bootloader);
  VZLinuxBootLoader *lbl = Bootloader_val(val_bootloader);
  [conf setBootLoader:lbl];
  CAMLreturn(Val_unit);
}


CAMLprim value caml_vm_set_serial_port_virtio(VZVirtioConsoleDeviceSerialPortConfiguration *spc, VZVirtualMachineConfiguration *conf)
{
  CAMLparam0();
  [conf setSerialPorts:@[spc]];
  CAMLreturn(Val_unit);
}

static struct custom_operations bootloader_ops = {
  "virtualization.bootloader",
  custom_finalize_default,
  custom_compare_default,
  custom_hash_default,
  custom_serialize_default,
  custom_deserialize_default,
  custom_compare_ext_default,
  custom_fixed_length_default,
};


// Linux Boot Loader, we allocate a pointer and save it
CAMLprim value caml_linux_boot_loader(value val_kernel_path)
{
  CAMLparam1(val_kernel_path);
  CAMLlocal1(v_bl);
  const char *path = String_val(val_kernel_path);
  NSString *url = [NSString stringWithUTF8String:path];
  NSURL *kernelURL = [NSURL fileURLWithPath:url];
  // patricoferris: Do we need to retain this... I never know...
  VZLinuxBootLoader *lbl = [[VZLinuxBootLoader alloc] initWithKernelURL:kernelURL];
  v_bl = caml_alloc_custom(&bootloader_ops, sizeof(VZLinuxBootLoader *), 0, 1);
  Bootloader_val(v_bl) = lbl;
  CAMLreturn(v_bl);
}
