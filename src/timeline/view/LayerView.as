package timeline.view
{
	import timeline.core.Frame;
	import timeline.core.Layer;
	import timeline.enums.EnumTweenType;
	import timeline.util.Util;
	import timeline.view.event.TimelineViewEvent;

	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;

	[Event(name="MOUSE_DOWN_FRAME", type="timeline.view.event.TimelineViewEvent")]
	[Event(name="MOUSE_UP_FRAME", type="timeline.view.event.TimelineViewEvent")]
	[Event(name="MOUSE_OVER_FRAME", type="timeline.view.event.TimelineViewEvent")]
	[Event(name="CLICK_LAYER", type="timeline.view.event.TimelineViewEvent")]
	/**
	 * @author tamt
	 */
	public class LayerView extends BaseView
	{
		private const blankKeyframeBgColor : int = 0xffffff;
		private const keyframeBgColor : int = 0xcccccc;
		private const tweenframeBgColor : int = 0xCCCCFF;
		private const shapeTweenframeBgColor : int = 0xCCFFCC;
		private const keyframeColor : int = 0x000000;
		private const blankKeyframeColor : int = 0xffffff;
		// 一个帧格的尺寸
		private var _frameW : Number = 8;
		private var _frameH : Number = 18;
		// 关键帧起始帧的标记的尺寸
		private var markW : Number = 5;
		private var markH : Number = 10;
		//
		private var _layer : Layer;
		// 画帧的容器
		private var framesContainer : Sprite;
		//
		private var _ui : MovieClip;
		private var outline_mc : MovieClip;
		private var lock_btn : SimpleButton;
		private var visible_btn : SimpleButton;
		private var title_tf : TextField;
		private var frames_bg : MovieClip;
		private var title_bg : MovieClip;
		private var selection_ui : Sprite;
		private var mediator : TimelineMediator;
		// 帧操作相关的右键菜单
		private var framesContextMenu : ContextMenu;

		public function LayerView(layer : Layer, ui : *, mediator : TimelineMediator)
		{
			super();
			this.mediator = mediator;

			this._layer = layer;

			this._ui = ui;
			this.buildUI();

			this.render();
		}

		private function buildUI() : void
		{
			outline_mc = this._ui['outline_mc'];
			lock_btn = this._ui['lock_btn'];
			visible_btn = this._ui['visible_btn'];
			frames_bg = this._ui['frames_bg'];
			title_tf = this._ui['title_tf'];
			title_bg = this._ui['title_bg'];

			this.framesContainer = new Sprite();
			this.frames_bg.addChild(this.framesContainer);

			selection_ui = new Sprite();
			this._ui.addChild(this.selection_ui);

			this.selection_ui.x = this.frames_bg.x;
			this.selection_ui.y = this.frames_bg.y;

			this.framesContainer.mouseEnabled = this.framesContainer.mouseChildren = false;
			this.frames_bg.mouseChildren = false;
			this.title_tf.mouseEnabled = this.title_tf.selectable = this.title_tf.mouseWheelEnabled = false;
			this.selection_ui.mouseChildren = this.selection_ui.mouseEnabled = false;

			// 事件侦听
			this.title_bg.addEventListener(MouseEvent.CLICK, layerMouseHandler);
			this.frames_bg.addEventListener(MouseEvent.MOUSE_DOWN, framesMouseHandler);
			this.frames_bg.addEventListener(MouseEvent.MOUSE_MOVE, framesMouseHandler);
			this.frames_bg.addEventListener(MouseEvent.MOUSE_UP, framesMouseHandler);

			if (this.ui.stage)
			{
				this.onAdded();
			}
			else
			{
				this.ui.addEventListener(Event.ADDED_TO_STAGE, onAdded);
			}
		}

		private function onAdded(event : Event = null) : void
		{
			this.ui.removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			// 创建右键菜单
			framesContextMenu = new ContextMenu();
			framesContextMenu.hideBuiltInItems();

			var tweenMenuItem : ContextMenuItem = new ContextMenuItem("add tween");
			tweenMenuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, contextMenuEventHandler);

			var removeTweenMenuItem : ContextMenuItem = new ContextMenuItem("remove tween");
			removeTweenMenuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, contextMenuEventHandler);

			framesContextMenu.customItems.push(tweenMenuItem, removeTweenMenuItem);
			// 设置菜单
			frames_bg.contextMenu = framesContextMenu;
			// (frames_bg.root as Sprite).contextMenu = framesContextMenu;
		}

		private function contextMenuEventHandler(event : ContextMenuEvent) : void
		{
			var menuItem : ContextMenuItem;
			menuItem = event.currentTarget as ContextMenuItem;
			switch(event.type)
			{
				case ContextMenuEvent.MENU_ITEM_SELECT:
					switch(menuItem.caption)
					{
						case "add tween":
							this.mediator.createMotionTween();
							break;
						case "remove tween":
							this.mediator.removeMotionTween();
							break;
						default:
					}
					break;
				default:
			}
		}

		override public function destroy() : void
		{
			if (this.frames_bg)
			{
				this.frames_bg.removeEventListener(MouseEvent.MOUSE_DOWN, framesMouseHandler);
				this.frames_bg.removeEventListener(MouseEvent.MOUSE_MOVE, framesMouseHandler);
				this.frames_bg.removeEventListener(MouseEvent.MOUSE_UP, framesMouseHandler);
			}

			if (this.title_bg)
			{
				this.title_bg.removeEventListener(MouseEvent.CLICK, layerMouseHandler);
			}

			super.destroy();
		}

		private function framesMouseHandler(event : MouseEvent) : void
		{
			event.stopImmediatePropagation();
			switch(event.type)
			{
				case MouseEvent.MOUSE_DOWN:
					dispatchEvent(new TimelineViewEvent(TimelineViewEvent.MOUSE_DOWN_FRAME));
					break;
				case MouseEvent.MOUSE_MOVE:
					dispatchEvent(new TimelineViewEvent(TimelineViewEvent.MOUSE_MOVE_FRAME));
					break;
				case MouseEvent.MOUSE_UP:
					dispatchEvent(new TimelineViewEvent(TimelineViewEvent.MOUSE_UP_FRAME));
					break;
				default:
			}
		}

		private function layerMouseHandler(event : MouseEvent) : void
		{
			switch(event.type)
			{
				case MouseEvent.CLICK:
					this.dispatchEvent(new TimelineViewEvent(TimelineViewEvent.CLICK_LAYER));
					break;
				default:
			}
		}

		public function render() : void
		{
			//
			this.title_tf.text = this.layer.name;
			// color
			if (this.outline_mc && this.outline_mc.fill_mc)
			{
				this.outline_mc.fill_mc.visible = !this.layer.outline;
				(this.outline_mc.fill_mc as DisplayObject).transform.colorTransform = Util.getTintColorTransform(this.layer.color);
			}

			// 清除已有绘制
			Util.removeAllChildren(framesContainer);
			framesContainer.graphics.clear();

			for (var i : int = 0; i < this.layer.frames.length; i)
			{
				var frame : Frame = this.layer.frames[i];

				// 绘制背景
				var bgColor : int = this.getFrameBgColor(frame);

				framesContainer.graphics.lineStyle(0, 0x0);
				framesContainer.graphics.beginFill(bgColor, 1);
				framesContainer.graphics.drawRect(frame.startFrame * _frameW, 0, frame.duration * _frameW, _frameH - .5);
				framesContainer.graphics.endFill();

				// 绘制关键帧起始帧标记(圆形)
				var markColor : int = frame.hasElement() ? keyframeColor : blankKeyframeColor;
				framesContainer.graphics.lineStyle(1, 0x0, frame.hasElement() ? 0 : 1);
				framesContainer.graphics.beginFill(markColor);
				framesContainer.graphics.drawCircle(frame.startFrame * _frameW + _frameW / 2, _frameH / 2, markW / 2);
				framesContainer.graphics.endFill();

				// 绘制动画箭头
				if (frame.tweenType == EnumTweenType.MOTION || frame.tweenType == EnumTweenType.SHAPE)
				{
					if (frame.duration > 2)
					{
						var arrow : Sprite;
						var nextKeyframe : Frame = null;
						if ((frame.startFrame + frame.duration) < this.layer.frameCount) nextKeyframe = this.layer.frames[frame.startFrame + frame.duration];
						if (nextKeyframe && nextKeyframe.hasElement() && Util.compareElements(nextKeyframe.elements, frame.elements))
						{
							arrow = this.mediator.skin.getSkinInstance("tween_ui");
						}
						else
						{
							arrow = this.mediator.skin.getSkinInstance("broken_tween_ui");
						}
						arrow.mouseChildren = arrow.mouseEnabled = false;
						arrow.x = (frame.startFrame + 1) * _frameW;
						arrow.y = 0;
						arrow.width = _frameW * (frame.duration - 1);
						arrow.height = _frameH;

						this.framesContainer.addChild(arrow);
					}
				}
				else
				{
					// 绘制关键帧结束帧标记(矩形)
					if (frame.duration > 1)
					{
						framesContainer.graphics.lineStyle(1, 0x0);
						framesContainer.graphics.beginFill(0xffffff);
						framesContainer.graphics.drawRect((frame.startFrame + frame.duration - 1) * _frameW + _frameW / 2 - markW / 2, _frameH / 2 - markH / 2, markW, markH);
						framesContainer.graphics.endFill();
					}
				}

				i += frame.duration;
			}
		}

		private function getFrameBgColor(frame : Frame) : uint
		{
			var color : uint;
			if (frame.hasElement())
			{
				switch(frame.tweenType)
				{
					case EnumTweenType.NONE:
						color = keyframeBgColor;
						break;
					case EnumTweenType.MOTION:
						color = tweenframeBgColor;
						break;
					case EnumTweenType.MOTION:
						color = shapeTweenframeBgColor;
						break;
					default:
				}
			}
			else
			{
				color = blankKeyframeBgColor;
			}

			return color;
		}

		/**
		 * 鼠标所在的那一帧
		 */
		public function get frameIndexAtMouse() : int
		{
			return Math.floor(this.framesContainer.mouseX / _frameW);
		}

		public function get frameH() : Number
		{
			return _frameH;
		}

		public function get ui() : MovieClip
		{
			return _ui;
		}

		/**
		 * Layer处于选中状态时
		 */
		public function onSelected(select : Boolean) : void
		{
			if (select)
			{
				this.title_bg.gotoAndStop(2);
			}
			else
			{
				this.title_bg.gotoAndStop(1);
			}
		}

		public function get layer() : Layer
		{
			return _layer;
		}

		public function get frameW() : Number
		{
			return _frameW;
		}

		/**
		 * 选择帧时
		 */
		public function onSelectedFrames(startFrameIndex : int, endFrameIndex : int) : void
		{
			var ui : Sprite = this.mediator.skin.getSkinInstance("selection_ui");
			ui.x = startFrameIndex * this.frameW;
			ui.width = (endFrameIndex - startFrameIndex + 1) * this.frameW;
			ui.height = this.frameH;
			this.selection_ui.addChild(ui);
		}

		/**
		 * 清除所选帧的显示
		 */
		public function clearSelectedFrames() : void
		{
			Util.removeAllChildren(selection_ui);
		}

		public function onUpdate() : void
		{
			this.render();
		}
	}
}
