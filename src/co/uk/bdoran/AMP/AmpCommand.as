package co.uk.bdoran.AMP
{
	import avmplus.getQualifiedClassName;
	
	import flash.utils.getDefinitionByName;

	public class AmpCommand
	{
		public var args : Object;
		public var response : Object;
		public var requiresAnswer : Boolean = true;
		
		public static const AMP_STRING : String = "AMP_STRING";
		public static const AMP_INTEGER : String = "AMP_INTEGER";
		public static const AMP_BOOLEAN : String = "AMP_BOOLEAN";
		
		public function AmpCommand(){
		}
		
		public function getCommandName() : String{
			var className : String = getQualifiedClassName( this ); 
			var start:uint = className.indexOf( "::" ) + 2;
			className = className.substring( start, className.length );
			return className;
		}
	}
}