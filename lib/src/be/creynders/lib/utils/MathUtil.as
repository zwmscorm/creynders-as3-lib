package be.creynders.lib.utils
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	public class MathUtil
	{
		
		static public const Q1 : int = 0;
		static public const Q2 : int = 1;
		static public const Q3 : int = 2;
		static public const Q4 : int = 3;
		static public const NUM_QUADRANTS : int = 4;
		
		static public function polygonIsClosed( points : Vector.<Point> ) : Boolean{
			var p0 : Point = points[ 0 ];
			var pN : Point = points[ points.length -1 ];
			return p0.x == pN.x && p0.y == pN.y;
		}
		
		/**
		 * 
		 */
		static public function calculateRegion( a : Point, b : Point ) : Number{
			return ( a.x * b.y ) - ( b.x * a.y )
		}
		
		/**
		 * Must be closed polygon, i.e. last point should be the same as first
		 * 
		 * see http://paulbourke.net/geometry/polyarea/
		 * 
		 * N.B.: fails for intersecting polygons!
		 */
		static public function calculateArea( points : Vector.<Point> ) : Number{
			if( ! polygonIsClosed( points ) ){
				throw new Error( 'First and last elements should be identical' );
			}
			var i : int;
			var n : int = points.length -1; //should be -1, we need to loop until the next to last element
			var sum : Number = 0;
			for ( i = 0; i<n; i++ ){
				var a : Point = points[ i ];
				var b : Point = points[ i + 1 ];
				sum += calculateRegion( a, b );
			}
			return Math.abs( sum /2 );
		}
		
		/**
		 * see http://paulbourke.net/geometry/polyarea/
		 */
		static public function calculateCentroid( points : Vector.<Point> ) : Point{
			if( ! polygonIsClosed( points ) ){
				throw new Error( 'First and last elements should be identical' );
			}
			
			var i : int;
			var n : int = points.length -1; //loop till next to last element
			var sumX : Number = 0;
			var sumY : Number = 0;
			var area : Number = 0;
			for ( i = 0; i<n; i++ ){
				var a : Point = points[ i ];
				var b : Point = points[ i + 1 ];
				var region : Number = calculateRegion( a, b );
				sumX += ( a.x + b.x ) * region;
				sumY += ( a.y + b.y ) * region;
				area += region;
			}
			
			area = area / 2;
			var output : Point;
			if( 0 != area ){
				output = new Point()
				output.x = sumX / ( 6 * area );
				output.y = sumY / ( 6 * area );
			}
			return output;
		}
		
		static public function degToRad( degrees : Number ) : Number{
			return degrees * Math.PI/180;
		}
		
		static public function radToDeg( radians : Number ) : Number{
			return radians * 180/Math.PI;
		}
		
		/**
		 * returns a Number/integer between [ begin ; end ]
		 * @param	begin
		 * @param	end
		 * @param	round
		 * @return
		 */
		static public function randomFromRange( begin : Number, end : Number, round : Boolean = false ) : Number {
			var decimals : int = ( round ) ? 0 : -1;
			return MathUtil.randomFromRangeWithDecimals( begin, end, decimals );
		}
		
		static public function randomFromRangeWithDecimals( begin : Number, end : Number, decimals : int = -1 ) : Number {
			var output : Number = begin + ( Math.random() * ( end - begin ) );
			return ( decimals >= 0 ) ? MathUtil.round( output, decimals ) : output;
			
		}
		
		static public function randomUint( value : uint ) : uint{
			return randomFromRange( 0, value );
		}
		
		static public function round( value : Number, decimals : int = 0 ) : Number{
			return _addDecimals( Math.round, value, decimals );
		}
		
		static public function floor( value : Number, decimals : int = 0 ) : Number{
			return _addDecimals( Math.floor, value, decimals );
		}
		
		static public function ceil( value : Number, decimals : int = 0 ) : Number{
			return _addDecimals( Math.ceil, value, decimals );
		}
		
		static private function _addDecimals( mathFunc : Function, value : Number, decimals : int ) : Number{
			var valueStr : String = String( value );
			var nrOfDec : int = valueStr.length - valueStr.indexOf( "." );
			if( nrOfDec > decimals ){
				var pow : int = Math.pow( 10, decimals );
				var output : Number = mathFunc.call( null, value * pow );
				return output / pow;
			}else{
				return value;
			}
		}
		
		static public function getDistance( p1 : Point, p2 : Point ) : Number {
			var dx : Number = p2.x-p1.x;
			var dy : Number = p2.y-p1.y;
			return Math.sqrt(dx * dx + dy * dy);
		}
		
		// Q1 | Q2
		// -- + --
		// Q4 | Q3
		static public function getPointInQuadrant( rectangle : Rectangle, q : int ) : Point {
			var dw2 : Number = rectangle.width / 2;
			var dh2 : Number = rectangle.height / 2;
			var rqX : Number = Math.random() * dw2;
			var rqY : Number = Math.random() * dh2;
			var leftX : int = Math.round( rectangle.x + rqX );
			var rightX : int = leftX + dw2;
			var upperY : int = Math.round( rectangle.y + rqY );
			var lowerY : int = upperY + dh2;
			switch( q ) {
				case Q1 : {
					return new Point( leftX, upperY );
				}
				
				case Q2 : {
					return new Point( rightX, upperY );
				}
				
				case Q3 : {
					return new Point( rightX, lowerY );
				}
				
				case Q4 : {
					return new Point( leftX, lowerY );
				}
			}
			
			return new Point( 0, 0 );
		}
		
		static public function randomBoolean() : Boolean {
			return ( Math.round( Math.random() ) == 1 );
		}
		
	}
}