package;

import flash.geom.Rectangle;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames.TexturePackerObject;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.frames.FlxFrame.FlxFrameAngle;
import flixel.graphics.frames.FlxFramesCollection.FlxFrameCollectionType;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.system.FlxAssets.FlxTexturePackerSource;
import flixel.FlxG;
import haxe.Json;
import openfl.Assets;
#if haxe4
import haxe.xml.Access;
#else
import haxe.xml.Fast as Access;
#end

class FakeSparrow extends FlxAtlasFrames {
    public static function fromSparrowData(Source:FlxGraphicAsset, Data:String):FlxAtlasFrames
    {
        var graphic:FlxGraphic = FlxG.bitmap.add(Source);
        if (graphic == null)
            return null;

        // No need to parse data again
        var frames:FlxAtlasFrames = FlxAtlasFrames.findFrame(graphic);
        if (frames != null)
            return frames;

        if (graphic == null || Data == null)
            return null;

        frames = new FlxAtlasFrames(graphic);

        var Description:String = Data;

        var data:Access = new Access(Xml.parse(Description).firstElement());

        for (texture in data.nodes.SubTexture)
        {
            var name = texture.att.name;
            var trimmed = texture.has.frameX;
            var rotated = (texture.has.rotated && texture.att.rotated == "true");
            var flipX = (texture.has.flipX && texture.att.flipX == "true");
            var flipY = (texture.has.flipY && texture.att.flipY == "true");

            var rect = FlxRect.get(Std.parseFloat(texture.att.x), Std.parseFloat(texture.att.y), Std.parseFloat(texture.att.width),
                Std.parseFloat(texture.att.height));

            var size = if (trimmed)
            {
                new Rectangle(Std.parseInt(texture.att.frameX), Std.parseInt(texture.att.frameY), Std.parseInt(texture.att.frameWidth),
                    Std.parseInt(texture.att.frameHeight));
            }
            else
            {
                new Rectangle(0, 0, rect.width, rect.height);
            }

            var angle = rotated ? FlxFrameAngle.ANGLE_NEG_90 : FlxFrameAngle.ANGLE_0;

            var offset = FlxPoint.get(-size.left, -size.top);
            var sourceSize = FlxPoint.get(size.width, size.height);

            if (rotated && !trimmed)
                sourceSize.set(size.height, size.width);

            frames.addAtlasFrame(rect, sourceSize, offset, name, angle, flipX, flipY);
        }

        return frames;
    }
}