package
{
	import co.uk.bdoran.AMP.AmpCommand;
	
	public class Sum extends AmpCommand{
		public function Sum(){
			this.args = { a : AMP_INTEGER, b : AMP_INTEGER };
			this.response = { total : AMP_INTEGER };
		}
	}
}