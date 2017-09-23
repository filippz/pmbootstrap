def variables(args, flavor, method):
    _cmdline = args.deviceinfo["kernel_cmdline"]
    if "cmdline" in args and args.cmdline:
        _cmdline = args.cmdline

    if method == "fastboot":
        _partition_system = "system"
    else:
        _partition_system = args.deviceinfo["flash_heimdall_partition_system"] or "SYSTEM"
    if "partition" in args and args.partition:
        _partition_system = args.partition

    vars = {
        "$BOOT": "/mnt/rootfs_" + args.device + "/boot",
        "$FLAVOR": flavor if flavor is not None else "",
        "$IMAGE": "/home/user/rootfs/" + args.device + ".img",
        "$KERNEL_CMDLINE": _cmdline,
        "$PARTITION_KERNEL": args.deviceinfo["flash_heimdall_partition_kernel"] or "KERNEL",
        "$PARTITION_INITFS": args.deviceinfo["flash_heimdall_partition_initfs"] or "RECOVERY",
        "$PARTITION_SYSTEM": _partition_system,
        "$RECOVERY_ZIP": "/mnt/buildroot_" + args.deviceinfo["arch"] +
                         "/var/lib/postmarketos-android-recovery-installer"
                         "/pmos-" + args.device + ".zip",
    }

    return vars
