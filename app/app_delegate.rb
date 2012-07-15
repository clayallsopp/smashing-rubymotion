class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.applicationFrame)
    @window.makeKeyAndVisible

    @box = UIView.alloc.initWithFrame CGRectMake(0, 0, 100, 100)
    @box.backgroundColor = UIColor.blueColor
    @window.addSubview(@box)

    @button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @button.setTitle("Change Color", forState:UIControlStateNormal)
    @button.setTitle("Loading...", forState:UIControlStateDisabled)
    @button.setTitleColor(UIColor.lightGrayColor, forState:UIControlStateDisabled)
    @button.sizeToFit
    @button.frame = [[0, @box.frame.size.height + 20], @button.frame.size]
    @window.addSubview(@button)

    @button.addTarget(self, action:"button_tapped", forControlEvents:UIControlEventTouchUpInside)

    true
  end

  def button_tapped
    @button.enabled = false

    BubbleWrap::HTTP.get("http://www.colr.org/json/color/random") do |response|
      color_hex = BubbleWrap::JSON.parse(response.body.to_str)["colors"][0]["hex"]
      if color_hex and color_hex.length > 0
        @box.backgroundColor = String.new(color_hex).to_color
        @button.setTitle(color_hex, forState: UIControlStateNormal)
      else
        @button.setTitle("Error :(", forState: UIControlStateNormal)
      end
      @button.enabled = true
    end
  end
end