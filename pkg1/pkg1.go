package pkg1
import ("fmt")

func Echo(arg string) string {
	fmt.Println("pkg1.Echo called: "+arg)
	return arg
}
