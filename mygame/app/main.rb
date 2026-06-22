def boot(args)
  GTK.ffi_misc.gtk_dlopen("square")
end

def tick(args)
  ::FFI::CExt::square(42.0)
end
