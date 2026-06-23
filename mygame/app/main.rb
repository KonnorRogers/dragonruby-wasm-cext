def boot(args)
  GTK.ffi_misc.gtk_dlopen("square")
end

def tick(args)
  puts ::FFI::CExt::square(42.0)
end
