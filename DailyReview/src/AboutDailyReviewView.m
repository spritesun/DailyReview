#import "AboutDailyReviewView.h"
#import "UIColor+Additions.h"
#import "UIView+Additions.h"

//TODO: could refactor with FullPageTextView
static NSString *dailyReviewIntro = @"功过格介绍\n\n    逐日登记自己所行之善恶事，藉以考查功过之表格或书籍，称为功过格。即将人类行为之功过善恶予以分类，并明定善恶之点数，依此作为判定行为之标准，并作为权衡鬼神降与福祸之依准，乃属劝人行善之书。此种藉善恶之多寡而决定鬼神降福祸之思想，最早见于东晋葛洪所作抱朴子一书，为道教之根本思想。近世承继此思想者很多。即以具体现实之善恶行为，详细计算点数，阐说善因善果、恶因恶果，此系功过格之特质。具体制定功过格之条目与内容之作法，最古者当推金大定十一年（1171）道士净明道所作之太微仙君功过格，立有功格三十六条、过律三十九条，规定治人疾病、救人性命、传授经教、为人祈禳、劝人为善等，皆予记功，反之行不仁、不善、不义、不轨等事则记过，逐日记录，一月一小比，一年一大比，善多者得福，过多者得咎。据清代石成金之‘传家宝’记载，宋代之范仲淹、苏洵等人亦皆作有功过格，名闻一时。然至明万历三十二年（1604），云栖袾宏着自知录、云谷禅师授功过格之后，始普及一般民众。\n[摘自佛学大词典]\n\n功过格的流通意义\n\n    功过格是修行者实践道德的指导书，像店主在账簿上记数般，逐日登记行为的善恶在一记分册上。有学者认为这种道德记账的体裁，与中国商业簿记的发达不无关系，因此称为「道德记账法」(MoralBook-keeping)。一位日本学者评论说：「功过格的出现，标志著中国人认识到，可用自己的手改变自己的命运，改变吉凶，这是他们精神生活中划时代的成果」（见福井康顺等监修、朱越利译《道教》第一卷，第146页）。";

@implementation AboutDailyReviewView

@synthesize textView = textView_;

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        UIColor *bgColor = [UIColor colorWithRed:0.961 green:0.937 blue:0.863];
        self.backgroundColor = bgColor;
        [self initTextView];
        [self initBgView];
    }
    return self;
}

- (void)initTextView {
    const CGFloat inset = 10;
    textView_ = [[UITextView alloc] initWithFrame:CGRectMake(inset, 0, self.width - 2 * inset, self.height)];
    textView_.backgroundColor = [UIColor clearColor];
    textView_.text = dailyReviewIntro;
    textView_.font = [UIFont systemFontOfSize:21];
    textView_.textColor = [UIColor colorWithRed:.247 green:.165 blue:.094];
    textView_.editable = NO;
    textView_.showsVerticalScrollIndicator = NO;
    [self addSubview:textView_];
}

- (void)initBgView {
    UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"about-bg"]];
    textView_.backgroundView = bgView;

    CGSize contentSize = textView_.contentSize;
    bgView.top = contentSize.height;
    bgView.left = 190;
    textView_.contentSize = CGSizeMake(contentSize.width, contentSize.height + bgView.height + 20);
}


@end
