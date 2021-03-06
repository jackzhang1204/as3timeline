package timeline.core
{
	import timeline.enums.EnumTweenType;
	import timeline.enums.validator.EnumsValidator;
	import timeline.core.elements.Element;

	/**
	 * Frame 对象表示图层中的帧。 
	 * @productversion Flash MX 2004。
	 * @see http://help.adobe.com/zh_CN/flash/cs/extend/WS5b3ccc516d4fbf351e63e3d118a9024f3f-7f6e.html
	 */
	public class Frame
	{
		private var _elements : Vector.<Element>;
		private var _startFrame : int;
		private var _duration : int = 1;
		private var _name : String;
		private var _tweenType : String = EnumTweenType.NONE;

		public function Frame()
		{
		}

		/**
		 * 一个字符串，它指定帧的名称。
		 * @return %RETURN%
		 * @example <p>下面的示例将顶部图层中第一帧的名称设置为 "First Frame"，然后将 name 属性的值存储在 frameLabel 变量中：</p>
		 * @usage <pre>frame.name</pre>
		 * @productversion Flash MX 2004。
		 * @see http://help.adobe.com/zh_CN/flash/cs/extend/WS5b3ccc516d4fbf351e63e3d118a9024f3f-7abc.html
		 */
		public function get name() : String
		{
			return _name;
		}

		/**
		 * 属性；一个字符串，它指定帧的名称。 
		 * @return %RETURN%
		 * @example <p>下面的示例将顶部图层中第一帧的名称设置为 "First Frame"，然后将 name 属性的值存储在 frameLabel 变量中：</p>
		 * @usage <pre>frame.name</pre>
		 * @productversion Flash MX 2004。
		 * @see http://help.adobe.com/zh_CN/flash/cs/extend/WS5b3ccc516d4fbf351e63e3d118a9024f3f-7abc.html
		 */
		public function set name(value : String) : void
		{
			this._name = value;
		}

		/**
		 * 只读属性；一个整数，它表示帧序列中帧的数量。
		 * @return %RETURN%
		 * @example <p>下面的示例将从顶部图层的第一帧开始的帧序列中的帧数存储在 frameSpan 变量中：</p>
		 * @usage <pre>frame.duration </pre>
		 * @productversion Flash MX 2004。
		 * @see http://help.adobe.com/zh_CN/flash/cs/extend/WS5b3ccc516d4fbf351e63e3d118a9024f3f-7abf.html
		 */
		public function get duration() : int
		{
			return _duration;
		}

		/**
		 * 只读属性；Element 对象的数组（请参阅 Element 对象）。数组中的元素顺序就是它们在 FLA 文件中的存储顺序。如果在舞台上存在多个形状，并且每个形状都未组合，则 Flash 将它们作为单个元素处理。如果每个形状都经过组合，舞台上便存在多个组，Flash 将这些组作为单独的元素处理。换句话说，Flash 将所有原始的未组合形状作为单个元素处理，无论舞台上存在多少单独的形状。举例来说，如果一个帧包含三个原始的未组合形状，则该帧中的 elements.length 返回值 1。若要解决此问题，请分别选择每个形状，然后将其组合在一起。
		 * 其实elements总是与startFrame帧的elements是一样的
		 * @return %RETURN%
		 * @example <p>下面的示例将顶部图层第一帧中的一组当前元素存储在 myElements 变量中：</p>
		 * @usage <pre>frame.elements</pre>
		 * @productversion Flash MX 2004。
		 * @see http://help.adobe.com/zh_CN/flash/cs/extend/WS5b3ccc516d4fbf351e63e3d118a9024f3f-7f6b.html
		 */
		public function get elements() : Vector.<Element>
		{
			return _elements;
		}

		public function hasElement() : Boolean
		{
			return elements && elements.length;
		}

		/**
		 * 属性；一个字符串，它指定补间的类型；可接受值为 "motion"、"shape" 或 "none"。指定 "none" 值将删除补间动画。使用 timeline.createMotionTween() 方法创建一个补间动画。 如果指定 "motion" 值，帧中的对象必须为元件、文本字段或组合对象。该对象将从它在当前关键帧中的位置补间至下一关键帧中的位置。 如果指定 "shape"，帧中的对象必须为形状对象。该对象将从当前关键帧中的形状开始，混合成下一关键帧中的形状。
		 * @return %RETURN%
		 * @example <p>下面的示例指定一个对象为补间动画，所以它应从当前关键帧中的位置补间至后续关键帧中的位置：</p>
		 * @usage <pre>frame.tweenType</pre>
		 * @productversion Flash MX 2004。 
		 * @see http://help.adobe.com/zh_CN/flash/cs/extend/WS5b3ccc516d4fbf351e63e3d118a9024f3f-7aab.html
		 */
		public function get tweenType() : String
		{
			return _tweenType;
		}

		/**
		 * 属性；一个字符串，它指定补间的类型；可接受值为 "motion"、"shape" 或 "none"。指定 "none" 值将删除补间动画。使用 timeline.createMotionTween() 方法创建一个补间动画。 如果指定 "motion" 值，帧中的对象必须为元件、文本字段或组合对象。该对象将从它在当前关键帧中的位置补间至下一关键帧中的位置。 如果指定 "shape"，帧中的对象必须为形状对象。该对象将从当前关键帧中的形状开始，混合成下一关键帧中的形状。
		 * @return %RETURN%
		 * @example <p>下面的示例指定一个对象为补间动画，所以它应从当前关键帧中的位置补间至后续关键帧中的位置：</p>
		 * @usage <pre>frame.tweenType</pre>
		 * @productversion Flash MX 2004。 
		 * @see http://help.adobe.com/zh_CN/flash/cs/extend/WS5b3ccc516d4fbf351e63e3d118a9024f3f-7aab.html
		 */
		public function set tweenType(value : String) : void
		{
			if (EnumsValidator.validate(EnumTweenType, value))
			{
				_tweenType = value;
			}
		}

		/**
		 * 只读属性；序列中第一帧的索引。
		 * @return %RETURN%
		 * @example <p>在下面的示例中，stFrame 是帧序列中第一帧的索引。在此示例中，帧序列跨越从第 5 帧到第 10 帧的 6 个帧。因此，第 5 帧到第 10 帧中任何一帧的 stFrame 值均为 4（请注意帧的索引值和帧的编号值是不同的）。 </p>
		 * @usage <pre>frame.startFrame</pre>
		 * @productversion Flash MX 2004。
		 * @see http://help.adobe.com/zh_CN/flash/cs/extend/WS5b3ccc516d4fbf351e63e3d118a9024f3f-7aad.html
		 */
		public function get startFrame() : int
		{
			return _startFrame;
		}

		/**
		 * 删除帧的内容, elements将为null
		 */
		public function clearContent() : void
		{
			elements = null;
		}

		[Exclude]
		public function set startFrame(startFrame : int) : void
		{
			_startFrame = startFrame;
		}

		[Exclude]
		public function set duration(duration : int) : void
		{
			_duration = duration;
		}

		[Exclude]
		public function set elements(elements : Vector.<Element>) : void
		{
			_elements = elements;

			if (!_elements)
			{
				this.tweenType = EnumTweenType.NONE;
			}
		}

		/**
		 * 添加一个Element
		 */
		public function addElement(element : Element) : void
		{
			if (!element) return;

			if (!elements)
			{
				elements = new Vector.<Element>();
			}

			if (elements.indexOf(elements) < 0) elements.push(element);
		}

		/**
		 * 克隆elements
		 */
		public function cloneElements() : Vector.<Element>
		{
			var eles : Vector.<Element>;
			if (elements)
			{
				eles = new Vector.<Element>();
				for (var i : int = 0; i < elements.length; i++)
				{
					eles.push(elements[i].clone());
				}
			}
			return eles;
		}
	}
}
