// Created by Long Sun on 12/11/12.
//  Copyright (c) 2012 Itty Bitty Apps. All rights reserved.

#import "BaihuaViewController.h"
#import "FullPageTextView.h"
#import "UIView+Additions.h"

static NSString *const baihuaContent = @"功过格白话解\n"
        "\n"
        "本文由净空法师专集网站制作，在此处稍作整理并引用。\n"
        "顶礼净空法师。\n"
        "\n"
        "[1] 功\n"
        "1、救免一人死\n"
        "救一人免于死难。 \n"
        "2、完一妇女节\n"
        "保全一妇女的节操。\n"
        "3、阻人不溺一子女\n"
        "溺有二义，一是溺爱，二是溺水。劝阻他人不可溺爱子女，或是以溺水的手段，遗弃杀害子女。（似是后者的情况比较符合文义）\n"
        "4、为人延一嗣\n"
        "为人延续一后代子嗣。\n"
        "5、免堕一胎\n"
        "学佛之人，不仅自己不堕胎，亦应劝导身边的亲朋好友，不要堕胎。儿女与父母是有直接而密切的缘分，若无缘分，求儿女求不到。儿女与父母有四种因缘，所谓报恩、报怨、讨债、还债；实际而言，人与一切众生都有这四种缘。因此，若这个小孩是来报恩的，你堕胎就是杀了他，恩变成仇；如果是来报怨的，仇恨就更深了。讨债、还债再加上命债，因果通三世，冤冤相报没完没了。我们这一世遭遇的种种不幸，是过去生中造的不善业；这一生当中能够过得很安稳、很自在，一切称心如意，也是过去生中累积的善因。善因必得善果，恶因一定得恶报。\n"
        "6、当欲染境，守正不染\n"
        "处于欲染境界之中，而能端身正意，不为欲爱所染。\n"
        "7、收养一无倚\n"
        "收养一个无依无靠之人。 \n"
        "8、葬一无主骸骨\n"
        "这个情况古代比较常见，现代则需要通报有关人员来处理。现代可以理解为，为一孤寡无亲之人处理身后事。另外，如今地产业发达，往往在建造楼房时，时常会从地下挖出一堆白骨，应妥当安葬，不可随便扔弃！要知死者为大的道理。\n"
        "9、救免一人流离\n"
        "救助一人免于流离失所之难。\n"
        "10、救免一人军徒重罪\n"
        "救免一人军徒重罪。\n"
        "11、白一人冤\n"
        "说明一个人的冤曲，令其洗刷冤情，还公道于人。司法界的人员，为人平反冤案，使冤者得雪，亦属此。\n"
        "12、发一言利及百姓\n"
        "发表一次有利于社会百姓的言论。\n"
        "13、施一葬地与无土之家\n"
        "布施土地于贫穷无地之人，安葬已逝去的亲人。\n"
        "14、化一为非者改行\n"
        "教化一个为非作歹的人，改恶从善。\n"
        "15、度一受戒弟子\n"
        "度化一受戒弟子，使其有所领悟或成就。\n"
        "16、完聚一人夫妇\n"
        "夫妇之道，是人伦大道的开始，不可轻易离婚，亦不可教唆他人离婚。若见将破之婚姻，应婉转劝导，使其合于将破之际。或帮助分开的夫妻重聚。\n"
        "17、收养一无主遗弃门孩\n"
        "现今社会两性关系泛滥，被弃婴孩，时有所闻，若有发现，应收养或是送往社会福利机构安置，保全其生命。\n"
        "18、成就一人德业\n"
        "出钱或是出力，成就一个人的道德学问。如资助希望工程、设立奖学金，皆属此。\n"
        "19、荐引一有德人\n"
        "推荐引导一个有道德品行的人为人民服务\n"
        "20、除一人害\n"
        "除去危害于一方的一个恶人。\n"
        "21、编纂一切众经法\n"
        "编辑一切正法经典用于宣扬流通。\n"
        "22、以方术治一人重病\n"
        "用医学、卜筮、星相等治愈人严重的疾病。\n"
        "23、发至德之言\n"
        "至德即崇高的德性，发表与德性相应的言论。\n"
        "24、有财有势可使而不使\n"
        "虽然有财有势，但不以此财势威逼于人。\n"
        "25、善遣妾婢\n"
        "现今家庭富裕者，有雇请佣人，应善待佣人，遣离时应给予丰厚的资遣费，不可刻薄吝啬。\n"
        "26、救一有力报人之畜命\n"
        "救护一只有力报答人类的畜生的生命，如牛、马等。\n"
        "27、劝息一人讼\n"
        "劝一人止息诤讼。\n"
        "28、传一人保益性命事\n"
        "传授给一人戒杀吃素，有益身心健康的事例或技能。 \n"
        "29、编纂一保益性命经法\n"
        "搜集古今典籍中，有关修身养性长寿健康，有益于生命之文而编纂成书。如提倡戒杀吃素，传播健康的饮食观念，皆属此类。\n"
        "30、以方术治一人轻疾\n"
        "用医学、卜筮、星相等一技之长治愈人轻微的疾病。\n"
        "31、劝止传播人恶\n"
        "劝止传播别人的是非或坏事。谣言止于智者，即此之谓也。学佛之人，不仅口不说人恶，耳亦不应听恶人恶事、人我是非。遇传播人恶之人，应善巧劝阻！\n"
        "32、供养一贤善人\n"
        "供养一贤良、有道德的善人。\n"
        "33、祈福禳灾等，但许善愿不杀生\n"
        "祈福禳灾，这些民间信仰之事，应只许善愿，不可杀生祭祀。世人不明道理，往往杀生祭祀，不仅不能得福，反而招殃。「杀生祭祀鬼神愁」，一切的正神善鬼，绝不会享用人间血肉的祭祀，只有那些邪神邪鬼才会享用。学佛之人，应读诵大乘经典，礼佛拜忏，以此功德回向，必能蒙受佛慈加持，而满其善愿！\n"
        "34、救一无力报人之畜命\n"
        "救护一只无力报答救护之恩的畜生。\n"
        "35、受一横不嗔\n"
        "遇到一意外之灾不生气不抱怨。\n"
        "36、任一谤不辩\n"
        "受人毁谤而不辩白。古人云：「任他谤任他诽，把火烧天徒自疲，我闻恰似饮甘露，销融顿入不思议。」佛说四十二章经云：「佛言：有人闻吾守道，行大仁慈，故致骂佛。佛默不对；骂止，问曰：「子以礼从人，其人不纳，礼归子乎？」对曰：「归矣！」佛言：「今子骂我，我今不纳；子自持祸，归子身矣！」犹响应声，影之随形，终无免离。慎勿为恶！」当别人骂我们、诽谤我们，我们不接受，就好比你送礼物给我，我不肯接受，那么，骂人者还是要把这个罪过带回去的。应明白此理！\n"
        "37、受一逆耳言\n"
        "所谓良药苦口利于病，忠言逆耳利于行，逆耳之言，虽不中听，但能有利于身心，能增进德业品行！\n"
        "38、免一应责人\n"
        "免除一应受责罚之人，此为仁恕之道，教育为本，感人以德，不以刑罚惩处！晋代桑虞有果园在离家数里之外，园外有荆棘筑成的篱笆。瓜果初熟季节，有人翻过篱笆偷盗瓜果。他觉得篱笆上有荆棘，恐偷盗的人惊慌爬出时损伤身体，就叫家奴开出一条出路。等到偷盗者背着瓜出来，发现道路通畅，知道是桑虞叫人做的，非常惭愧，就将瓜果送到桑虞那儿，叩头谢罪。（晋书.孝友传.桑虞）\n"
        "39、劝养蚕、渔人、猎人、屠人等改业\n"
        "劝导养蚕、捕渔人、打猎人、杀猪宰牛的屠夫，放弃这种杀生造业的行业，而能改做其它行业。每个人的福报都有定，不论从事什么行业都能赚钱，养家糊口。何苦如此愚痴，而从事此类惨不忍睹又折损自己福报的杀生造罪的行业呢？ \n"
        "40、葬一自死畜类\n"
        "如自家养的家畜之类，自然死后，应给予安葬，不应剥其皮食其肉。如牛马等，它们辛苦耕田，人才有五谷可食，我们应心存感恩，给予好的安葬。学佛人要念佛回向，开示此等畜生，因过去的愚痴而堕入畜生道，今遇此胜缘，应一心念佛，求生净土。\n"
        "41、赞一人善\n"
        "赞扬别人的善行善事，这是随喜功德，其功德等同于行善之人，不可嫉妒障碍。\n"
        "42、掩一人恶\n"
        "隐恶扬善，是人之美德。见人恶应当反躬自省，我是否有这样的过失？有则改之，无则加勉。此人即是我之善知识，感激都来不及，又怎么可以宣扬他的过恶呢？\n"
        "43、劝息一人争\n"
        "因事与人相争，焉知我之不是呢？应以理相劝，息灭争论。\n"
        "44、阻人一非为事\n"
        "阻止别人做一件错事，并能劝令改正。\n"
        "45、济一人饥\n"
        "救济一饥饿之人，计为一功。\n"
        "46、留无归人一宿\n"
        "留无家可归之人，住一晚上，算作一功。\n"
        "47、救一人寒\n"
        "冬天，天寒地冻，常有人受到严寒的逼迫，遇人有此危险，应施于救助，令其免受寒冷。\n"
        "48、施药一服\n"
        "凡布施医药一服，计为一功。\n"
        "49、施行劝济人书文\n"
        "凡是印刷劝人向善、戒杀护生、慈悲济世之文章，其功德等同自己书写！\n"
        "50、诵经一卷\n"
        "佛经是修正我们思想行为的准则，务必要读诵正法经典，方能正其心诚其意，蒙受佛菩萨的教诲之益！\n"
        "51、礼忏百拜\n"
        "以真诚心礼拜忏悔，能消除一切恶业及灾难，解除累世怨结﹐增益福慧﹐功德巍巍不可思议。礼忏一百拜，计为一功。\n"
        "52、诵佛号千声\n"
        "以清净心念诵佛号千声。念佛的目的在于制心一处，将一切的妄念，归于一句阿弥陀佛，以一句阿弥陀佛取代无量的妄念。念佛时，若有妄念，不要理会妄念，只管提起正念，将一句阿弥陀佛，念得清楚，听得明白，记得清楚，出乎口、入乎耳、印乎心，心口耳一致，妄念自然就少了。\n"
        "53、讲演善法，谕及十人\n"
        "凡是讲演善法，劝人断恶修善，明达因果事理，劝谕十人，算作一功。\n"
        "54、兴事利及十人\n"
        "凡是兴建利人利己，富国强民的事，其利益能达到十个人，算作一功。\n"
        "55、拾得遗字一千\n"
        "凡是在路上，或是在我们生活的周围，看到有字纸，应把它捡起来，送往回收厂处理，或是送至焚化炉，这皆是爱惜字纸的善心善行。因为字是智慧的符号，人借助于文字，才得以学习文化、智慧，故对字纸应当尊重。\n"
        "56、饭一僧\n"
        "以饮食供养一位出家僧人。\n"
        "57、护持僧众一人\n"
        "护持一位出家人，令其身心安顿，无四事匮乏之虞，而能安心修道！\n"
        "58、不拒乞人\n"
        "若遇贫穷乞丐，随自己所有，以恭敬心施与，不可拒绝。贫穷者是悲田，能以敬心布施，就是以他的悲田，成就我的大悲拔苦、大慈与乐之心！\n"
        "59、接济人畜一时疲顿\n"
        "凡遇到人或是畜生，因一时的疲劳困顿，应给予接济帮助。如有人外出谋生或是求学，因不慎遗落钱财，或是受伤，又无人照料，遇此类状况，应给予帮助。若遇受伤的动物，应尽心救治，待其恢复健康，然后放归大自然！\n"
        "60、见人有忧，善为解慰\n"
        "凡见别人有忧心之事，应善巧方便，开解劝慰，令其释忧生喜。\n"
        "61、肉食人持斋一日\n"
        "虽未能吃素，但能发心在一日之中吃素。如初一、十五、六斋日、十斋日，佛菩萨圣诞、父母的诞辰日（或忌日），在这一天之中，不吃肉食，而能素食，并读经念佛，修清净功德！\n"
        "62、见杀不食\n"
        "看到杀动物的情景，即不食此肉。\n"
        "63、闻杀不食\n"
        "听到被杀动物的惨叫声，即不食此肉。\n"
        "64、为己杀不食\n"
        "常怀慈悲心，不吃专为自己而杀的肉食品。\n"
        "65、葬一自死禽类\n"
        "凡是见已死的飞禽走兽，暴尸于荒野或道路旁，应当埋葬，令其安息。\n"
        "66、放一生\n"
        "凡是一切有生命的众生，皆应爱护，放一生记一功。\n"
        "67、救一细微湿化之属命\n"
        "救一微弱细小的湿化类的生命，如蚯蚓等。\n"
        "68、作功果荐沉魂\n"
        "请僧人做超度法事，或是自己修持，读经念佛，以此功德，超荐沉沦的孤魂野鬼。\n"
        "69、散钱栗衣帛济人\n"
        "若遇地震、涝旱、灾荒、战争等天灾人祸，应广施钱财、食物、衣服等，周济灾民，使灾难中的人民获得安稳。即使无灾无难，若遇贫穷饥饿者，亦应施行救济。\n"
        "70、饶人债负\n"
        "若借人财物，而人无力偿还，不逼债，且能销毁字据，饶益别人。\n"
        "71、还人遗物\n"
        "若是有人不小心将财物遗失，拾得之后，应归还物主，不得占为己有。\n"
        "72、不义之财不取\n"
        "不仁不义、不是自己的金钱物品，不取不受。\n"
        "73、代人完纳债负\n"
        "代无力偿还债务的人，偿还债务。\n"
        "74、让地让产\n"
        "如安徽桐城六尺巷之由来，即是让地之结果。清朝康熙年间，文华殿大学士兼礼部尚书张英在京城做官，他桐城的老家与吴姓的邻居，发生了地皮的争执，于是家人将书信送往京城，请他出面处理。这位大学士看后立即回信说：「一纸书来只为墙，让他三尺又何妨。万里长城今犹在，不见当年秦始皇。」家人看了信后，主动让出三尺。邻居吴氏深受感动也让出三尺，就成了「六尺巷」。张英有这样的胸怀气度，不仅他本人官至宰相，其儿子张廷玉，亦是康熙、雍正、乾隆三朝宰相，可谓积阴德厚矣！\n"
        "75、劝人出财作种种功德\n"
        "发财不难，保财最难，应随分随力，劝导自己的亲朋好友同事，明白正确的理财观念，广行布施，如印经、放生、救济等，皆是积阴德的善行。果能行大布施，可保财富不失。\n"
        "76、不负寄托财物\n"
        "所谓受人之托，忠人之事，即此意也。对于朋友、亲族的托付，应严守承诺，不可见财而忘义。如唐朝的李勉，从小好学，个性沉厚高雅，神志光明。少年时代家境贫寒，曾经客游到梁宋地方，正巧和一位书生同住一家旅馆，书生染患重病将死，拿出所带的白金，对李勉说：「我已经不行了，现在左右无人知道，我死后，请你用这些白金替我办理后事，为我安葬，剩余的就全部赠送与你，请你收下吧！」李勉安慰答应了他，于是依照遗言，将他安葬，但是所剩白金，却暗中把它放在棺材底下。后来那书生的家属开坟墓时，掘出白金，终于归还其家属。唐肃宗做皇帝时提拔李勉为鉴察御史，后官位至宰相，其为人耿直清高，为官廉明无私。\n"
        "77.1、建仓平粜、修造路桥、疏河掘井\n"
        "修桥铺路，方便行走，疏导河流，不致因河道不通而淹大水，掘井是为方便一方人士的饮水。现今如疏通河道，大雨之时就不会有淹水之虑。提倡环保，保持河流山川的清洁；注意自来水的品质，勿使工业废水污染环境，人人有干净安全的饮用水。尤其，政府人员，更应积极为人民谋福利，传播此种良善的讯息，从事工业者，谨慎处理工业废水，勿使河川水源受到污染，皆属此。\n"
        "77.2、修置三宝寺院、造三宝尊像\n"
        "建造修复三宝寺院，塑造、彩绘、铸造、描画佛菩萨圣像。如《了凡四训》中讲述的，有一天，包凭到郊外旅游，偶然间到了一个村庄的寺院，看见观世音菩萨的圣像，暴露于野外，遭受风吹雨淋。他于心不忍，就把自己身上带的钱，拿出了十两银子，交给住持师父，作为修复寺院房屋殿宇之用。住持告诉他，修寺的工程很大，而银两太少，实在无法完成这件工程。于是包凭又把身上所带的四疋布，还有几件好的衣服，都是新购买的，卖了可以作为修寺资金。他的仆人劝他说：不要再把这件衣服也送了，包凭却说，「只要庙能修好，观音圣像不被雨淋，我自己就是裸露、赤膊也无所谓。」这种真诚的善心实在非常难得！庙修好以后，包凭带上父亲同去寺院。晚上住在寺内，包凭当夜梦见寺院的伽蓝菩萨来向他道谢，说「你的子孙应当会享有世间的官禄。」后来他的儿子包汴、孙子柽芳，果然考中进士，做了显赫的高官。凡是在三宝门中修福，应发如是之心，不求回报，所报则厚；有所求者，所报则薄。\n"
        "77.3、施香烛灯油等物、施茶水\n"
        "用香、烛、灯、油物供养三宝，或是布施茶水。\n"
        "77.4、舍棺木一切方便等事\n"
        "如我们在历史书籍上常读到，卖身葬父、卖身葬母、卖身葬夫之事迹，现今社会虽然比过去富裕，然亦有贫穷之人，若自己的邻里，或是偶尔路遇此等窘事，应伸出援手，助人度过难关，不计回报。如唐朝的郭元振，少年时代，就怀抱大志，才学俊秀，十六岁入太学当太学生时，有一次家人送来钱资四十万，恰有一位身穿丧服的陌生人，前来叩门求他帮助，自说家境贫寒，已有五代祖先未能安葬，请求借钱，用来治丧，元振深为同情，也不质问他的姓名，就将四十万钱全部赠送给他，丝毫不吝惜。\n"
        "\n"
        "[2] 过\n"
        "1、致一人死\n"
        "导致一人死亡。无论有意无意，造成他人失去生命，如酒后驾驶，医疗事故等等使人死亡。\n"
        "2、失一妇女节\n"
        "使一个妇女失去贞操。\n"
        "3、赞人溺一子女\n"
        "古时候有些生活困苦的人，孩子生太多了，或者是认为孩子命不吉祥，会忍痛溺死自己的孩子，这是一种十分残忍愚昧的行为，赞叹这种行为，罪等同于犯过者。\n"
        "4、绝一人嗣\n"
        "断人后代，使之后继无人。\n"
        "5、堕一胎\n"
        "堕胎等于杀害了一条小生命。\n"
        "6、破一人婚\n"
        "破坏一人婚姻。婚姻大事，要成人之美，不可破坏，否则让人抱恨终生，影响的是几个家庭的幸福。\n"
        "7、拋一人骸\n"
        "拋弃一人之遗骸。\n"
        "8、谋人妻女\n"
        "用手段谋夺别人的妻女。\n"
        "9、致一人流离\n"
        "造成一人流离失所。\n"
        "10、致一人军徒重罪\n"
        "致一人军徒重罪。\n"
        "11、教人不忠不孝大恶等事\n"
        "教人做不忠不孝或大恶等坏事。\n"
        "12、发一言害及百姓\n"
        "发表一个有损害人民百姓的言论，或促成一个与劳命伤财、无利于百姓的政策。若人人能做到，内孝养父母，外尽忠职守，则家庭幸福、社会安定、国家富强、世界和平，反之则是天下大乱。\n"
        "13、造谤污陷一人\n"
        "存心害人，无中生有，制造冤枉诽谤诬告陷害一人。\n"
        "14、摘发一人阴私与行止事\n"
        "揭发他人的阴私。《弟子规》云：「人有短，切莫揭，人有私，切莫说」。\n"
        "15、唆一人讼\n"
        "教唆一人兴讼（打官司）。\n"
        "16、毁一人戒行\n"
        "破坏一修行人的清净戒行。所谓，「宁搅千江水，莫动道人心」见戒行清净的人，应随喜赞叹，不可恶意毁谤、伤害，甚至破坏戒行。\n"
        "17、反背师长\n"
        "孝亲尊师是做人的根本，对老师的教诲要信受奉行，不能阳奉阴违，背师叛道。\n"
        "18、抵触父兄\n"
        "父子有亲，兄弟有情，不应顶撞冲动。\n"
        "19、离间人骨肉\n"
        "离间别人至亲关系。\n"
        "20、荒年积囤五榖不粜生索\n"
        "饥荒之年，囤积五榖，不肯慷慨救济灾民，还趁机坐索厚利。\n"
        "21、排摈一有德人\n"
        "有道德的人，必能扬善惩恶，树立良好的社会风气，如果为了一已私利，而排挤压制道德之人，其过大也。\n"
        "22、荐用一匪人\n"
        "推荐起用一心术不正的坏人。荐用孝廉贤才，方能造福于人民，服务于社会，若荐用心术不正，唯利是图的坏人担当重要职位，将是祸国殃民的灾难。\n"
        "23、平人一冢\n"
        "挖掘一人的坟墓。《弟子规》云：「事死者，如事生」，既使有再深再大的怨恨，亦不应掘其坟墓，令遗骨暴露荒野。\n"
        "24、凌孤逼寡\n"
        "侵犯欺压孤儿寡妇。恻隐之心，人皆有之，孤儿寡母最令人同情，要随缘随份帮助，不可侵犯欺压。\n"
        "25、受畜一失节妇\n"
        "接受藏匿一失去贞节的妇女。如今之包二奶，养情人，导致了多少妻离子散的家庭悲剧，亦是社会动乱不安的根源，不可不慎！\n"
        "26、畜一杀众生具\n"
        "收藏或购置一杀生用的工具。\n"
        "27、恶语向尊亲、师长、良儒\n"
        "恶言恶语对父母、师长、善知识。《弟子规》云：「尊长前，声要低」，孝敬父母，奉事师长，恭敬善知识是做人的根本，应以真诚心善侍，怎可以恶语相向？\n"
        "28、修合害人毒药\n"
        "酿造配制害人毒药。明知是对人有害的毒药，为了钱财昧了良心，如研制白粉、海洛英等等有害身心健康者，或为利益而生产对人体有危害的食物。有很大的罪过。\n"
        "29、非法用刑\n"
        "用不正当手段对人施加刑罚（滥用私刑）。\n"
        "30、毁坏一切正法经典\n"
        "毁损破坏一切正法经典。正法经典教人断恶修善，离苦得乐，如果毁损破坏，使人失去接受圣教的机会，这样是断人慧命，罪过很大。\n"
        "31、诵经时，心中杂想恶事\n"
        "读诵经典时，心打妄念，甚或杂想贪瞋痴等恶行恶事。\n"
        "32、以外道邪法授人\n"
        "把外道害人的邪法，传授于他人。末法世间，邪师邪法如恒河沙，千万要慎重。\n"
        "33、发损德之言\n"
        "发表与道德相违背的言论。发表损害道德的言论，邪知邪见，混淆视听，使人失去对圣贤道德的恭敬，其罪不小。\n"
        "34、杀一有力报人之畜命\n"
        "杀一有能力为人类服务的牲畜。\n"
        "35、讪谤一切正法经典\n"
        "毁谤一切正法经典。正法经典教人断恶修善，离苦得乐，毁谤经典，使人对经典失去信心，这是断人慧命，罪过很大。\n"
        "36、见一冤可白不白\n"
        "见到一冤枉之事可以澄清而没有澄清的，或者有能力平反冤案而没有为之平反。\n"
        "37、遇一病求救不救\n"
        "遇一病人求救而不施于援手。尤其医护人员，其目的在于救死扶伤，若遇疾病者，应及时的给予治疗帮助，若因病人无钱而不治疗，甚至视而不见，即有失医护的天职。\n"
        "38、阻绝一道路桥梁\n"
        "阻止隔断一道路或一桥梁的信道，若有急重症病，因道路之隔绝，而延后医治，或是死亡，等于间接杀生。故不应恶意阻隔或损坏道路桥梁。\n"
        "39、编纂一伤化词传\n"
        "编纂淫秽、有伤风化的书籍、漫画。如著作、编辑、出版黄色书籍、黄色光盘、漫画书等，蔽人聪明，坏人心志者，有碍身心健康者，皆属此。\n"
        "40、造一浑名歌谣\n"
        "创作一有污秽言词的歌谣 。如今流行的艳歌艳曲，甚至淫秽的电影，或是导人邪思邪行，迷人心志的言词、影片、剧情，皆属此。\n"
        "41、恶口犯平交\n"
        "恶口冒犯平素交友。君子之交淡如水，话到舌边留半寸，正所谓 「病从口入，祸从口出」。与人相处应互相尊重，不能恶言相向。\n"
        "42、杀一无力报人之畜命\n"
        "杀害一已无能力为人类服务的牲畜。如老残疾病的牛马羊狗等，它们为人类耕田、驰骋、供奶、看门等等，当它们生病了或者老了岂能忍心杀死呢？应知恩图报，供养终老，生病了要帮它医治。 \n"
        "43、非法烹炮生物，使受极苦\n"
        "礼曰：「天子无故不杀牛，大夫无故不杀羊，士无故不杀犬豕。」圣人好生，不暴殄物命，今之人类，为一己口腹之欲，不仅杀害生灵，且以残忍的手段，烹调烘烤生猛海鲜，使它们遭受剧痛惨死，殊不知「今朝痛饮动物血，来生且作兽中餐」。号称万物之灵的人类，可不慎乎？\n"
        "44、瞋一逆耳言\n"
        "听一句逆耳忠言，即生瞋恚恼怒心，不能虚心接受，不能落实有则改之、无则加勉的训诲。\n"
        "45、乖一尊卑次\n"
        "不讲礼节，不作礼让，不尊长者先、幼者后之道义。如《弟子规》云：「称尊长，勿呼名」。称呼长辈，不能直接叫他的名字。「路遇长，疾趋揖」。路上遇见前辈师长，应赶快上前致礼问好。\n"
        "46-（1）、责一不应责人\n"
        "责备不应该受责备的人。正所谓恶人也有可怜悯的地方，世上没有一个全是恶毫无善的人，也没有一个全是善毫无恶的人。所以，应当隐恶扬善，人人向善，国泰民安也。\n"
        "46-（2）、播一人恶\n"
        "传播一人恶行恶事。\n"
        "47、两舌离间一人\n"
        "挑拨离间一人，令其双方或其中一方不再信任。\n"
        "48、欺诳一无识\n"
        "欺负诈骗一无知无识之人\n"
        "49、毁人成功\n"
        "千方百计破坏妨碍他人成功。\n"
        "50、见人有忧，心生畅快\n"
        "看见他人忧虑重重，反而心情舒畅，快乐无比。\n"
        "51、见人失利、失名，心生欢喜\n"
        "见到别人失去财富，丧失名誉之时，心生欢喜，幸灾乐祸。\n"
        "52、见人富贵，愿他贫贱\n"
        "看见富贵者，嫉妒他人，希望别人贫穷困苦。\n"
        "53、失意辄怨天尤人\n"
        "在失意时，动辄怨天尤人，不能反省自己。\n"
        "54、分外营求\n"
        "于分外之事，作非分之想，苦心经营，希求得到。谚语所谓「一饮一啄，莫非前定」，命中有的，推也推不掉；命中无的，求也求不来。故心安理得，不作非分之求。然，命自我立。佛教我们要如理如法的求，所谓「佛氏门中，有求心应」。以纯净的心，纯善的行，遵弟子规，修十善业，改造命运，服务众生。\n"
        "55、没一人善\n"
        "故意隐藏埋没一人的善行善事。\n"
        "56、唆一人斗\n"
        "教唆一人发生斗殴争端事件。\n"
        "57、心中暗举恶意害人\n"
        "怀恨于心，暗中起恶意想谋害别人。\n"
        "58、助人为非一事\n"
        "帮助他人为非作歹，作一非法不合理之事。\n"
        "59、见人盗细物不阻\n"
        "看到别人盗用细小的物品，没有善意劝阻，令其知错。\n"
        "60、见人忧惊不慰\n"
        "看到别人忧虑或惊恐不安时，没有给予慰藉安抚。\n"
        "61、役人畜，不怜疲顿\n"
        "对待为自己工作服务的人和畜牲，不生怜悯之心，随意苛责，不加体恤，令其劳累过度。现今社会，出门则以车代步，无论公车或私车，皆应注意保养，爱护一切公共设施。\n"
        "62、不告人取一针一草\n"
        "不告知财物主人，随意取得一针一草。虽是细物，不足挂齿，但无论多少贵贱，不问自取皆属于偷。但于细微处见精神，这是不尊重别人的具体表现，也是德行涵养的证验。 \n"
        "63、遗弃字纸\n"
        "故意损坏或拋弃字纸书籍。古代印刷业不发达，文字书籍十分难得，所以对字纸都很爱惜。虽然现代字纸随处可见，但对于具有保存价值或有利于人类的善书善句字纸，就应当珍惜保存。\n"
        "64、暴弃五榖天物\n"
        "对于滋养人类的五谷杂粮，天地万物，不珍惜，不保养，任意废弃或粗暴对待。民以食为天，若是轻贱浪费、暴殄天物，果报很重。《太上感应篇白话解》记载：北宋政和年间，王黻依靠阿谀奉承取得宋徽宗的欢心，长久担任重要官职，弄权纳贿，势倾中外。家里养着千余口人，都不喜欢吃肥腻和甘甜的食品，即使宫中的物品也比不上他家的。他家厨房与相国寺为邻，每天把吃剩的白米香饭倒入沟中流出来，就像珠玉颗粒一般，相国寺僧人率领众小沙弥用竹筐捞起来，在河中淘干净，晒干，除了众僧食用外，还积存下十三囤。后来金人攻破汴京，徽、钦二帝被掳北去，王黻也被诛杀于流放的地方。留下老母吴氏，八十余岁，流落到京城，没有人赡养，就沿街讨吃。有一个过去他家的佣人看见后觉得很可怜，就叫了她声「老太太」。那吴氏说：「我是个乞丐婆子，官人施舍几文钱给我，稍可苟延残喘几日，便是莫大功德，不必称什么老太太。」那个佣人说：「相国寺煮粥救济贫民，老太太到那儿找饭吃，岂不比讨吃要饭更好。」于是就把她领到寺中，见山门上贴着告示：「王府剩余粮食煮粥接济穷人，吃尽为止。」僧人省彻知道她是王老夫人，也不胜感叹说「这原本是王太尉的东西，老夫人享用是应该的。」就拨出一间房让她居住，每顿饭都和众人一起吃粥。有一天，吴老太碗中的饭粒忽然都变成了蛆，老太太惊，倒掉另盛一碗，仍然变成蛆，还在蠕蠕而动。 众人皆惊恐不已，省彻说「每粒米都是大地的精华，农夫的血汗。王太尉不知爱惜，正象《内典》中所说的『作恶的人会殃及七祖』。就命老太太在佛像前忏悔，念佛百遍，再下筷时不变蛆了。后来老太太病死，破衣服中虮子、虱子爬满了，用烂席子裹了尸体埋掉。又如《太上感应篇汇篇》记载，有一个老妇，在一官宦人家从事炊煮工作，每次煮饭，都会多做饭菜，吃剩下的饭菜，全部弃于水沟之中。有一天这个妇人生病死了，突然又活过来，说：「有两船遗弃食物，臭秽无比，一个人拿着铁棒捶挞我，说这是我生前所丢弃的食物，强逼着我吃了数口，便腹胀难忍，唉！什么时候才能吃尽啊！」说完之后就死了。由上可知，一定要爱惜物命，不可浪费食物。\n"
        "65、负一约\n"
        "不讲信用，负于一约定。 \n"
        "66、醉犯一人\n"
        "饮酒喝醉，失去礼节冒犯一人。\n"
        "67、见一人饥寒不救济\n"
        "遇见饥饿交迫处于困苦者，不生恻隐之心，不伸救援之手及时给予救济帮助。\n"
        "68、诵经差漏一字句\n"
        "读诵经文时，注意力不集中，心念散乱，读错或漏掉一字一句。如《金刚经持验录》中记载，明朝嘉靖年间，少保戚继光，平日持诵金刚经，在行伍间仍不稍停辍。他担任副总时，有一天晚上，梦见一位阵亡的士兵向他说：「明天叫我的妻子到您这儿来，请您为我诵金刚经一卷，以便度脱。」第二天早上，那个士兵的妻子果然前来，一如梦中所说。戚继光当天早上就为他诵经，夜里梦见那位士兵向他致谢道：「感谢主帅您亲自诵经，因为中间杂夹有『不用』二字，我虽然可以脱离痛苦，但尚不能超生。」继光深感惊讶，他回忆诵经的时候，夫人曾命婢女送茶饼来，他挥手拒绝，虽然没有说出口，但是意思是「不用」。继光再度闭户虔诵，又梦见士兵向他致谢，说已经超升了。 他时常将此事告诉幕客，终于被传扬开来。因此，诵经一定要专心，念得字句清楚，耳朵听得明白，全神贯注一心念诵。\n"
        "69、僧人乞食不与\n"
        "遇到出家僧人乞食养身，予以拒绝不供给。虚云老和尚云：「佛、法二宝，赖僧宝扶持，若无僧宝，佛法二宝无人流布，善根无处培植，因此斋僧功德为最大。」《佛说布施经》云：「若以上妙饮食供养三宝。得五种利益。身相端庄。气力增盛。寿命延长。快乐安稳。成就辩才。」譬如佛在经上说，有人布施供养辟支佛一钵饭，他所得的褔，九十亿劫不受贫穷的果报。供养一钵饭是很小的事情，怎么会得这么大的褔报？得褔大小在供养的心量。如果是以清净心、平等心、真诚心，褔报就大了。僧宝是世间无上福田，应以恭敬心、清净心，供养僧宝，得福无量。 \n"
        "70、拒一乞人\n"
        "拒绝一乞人的乞讨。\n"
        "71、食酒肉五辛，诵经登三宝地\n"
        "饮酒食肉，大量食用五辛植物，带着刺激性的秽浊之气，诵经念佛，或登上佛法僧三宝净地。《楞严经》云：「是诸众生求三摩提，当断世间五种辛菜，是五种辛熟食发淫，生啖增恚，如是世界食辛之人，纵能宣说十二部经，十方天仙嫌其臭秽，咸皆远离，诸饿鬼等，因彼食次舐其唇吻，常与鬼住，福德日销，长无利益，是食辛人修三摩地，菩萨天仙，十方善神，不来守护，大力魔王得其方便。现作佛身来为说法，非毁禁戒，赞淫怒痴，命终自为魔王眷属，受魔福尽堕无间狱。阿难，修菩提者永断五辛。」五辛即蒜、葱、兴渠、韭、薤，另一说为大蒜、小蒜、葱、韭菜、兴蕖(洋葱)。五辛有多种说法不一，读者可综合参考。五辛虽具有「杀菌」之用，但大量食用，对于修学功夫尚未成就的人，是有妨碍的。生吃容易动肝火，瞋怒与暴躁；熟吃容易产生荷尔蒙，引起性冲动。妨碍清净心，妨碍修定。故佛制戒食五辛，即戒荤也。\n"
        "72、服一非法服\n"
        "衣冠不整洁，穿戴不符合自己身份或所处环境的服饰。\n"
        "73、食一报人之畜等肉\n"
        "食用对于人类有恩的家畜之肉。如狗能看守家园，牛可替人耕田，故不可宰杀而食其肉。\n"
        "74、杀一细微湿化属命及覆巢破卵等事\n"
        "杀一微弱细小的湿化类生命，如蚯蚓等。以及倾毁巢窝、破壳取卵等事，如捣鸟巢，破龟蛋等。\n"
        "75、背众受利，伤用他钱\n"
        "于团体中，背着大众私受财物谋取私利，伤害集体利益，擅用他人钱财。\n"
        "76、负贷\n"
        "背信弃义，有负于诺言，不能按期归还信贷，不能兑现承诺之事。\n"
        "77、负遗\n"
        "答应别人的嘱托，不去履行或没有完成。\n"
        "78、负寄托财物\n"
        "见财忘义，负于承诺，将寄托的财物占为己有，或没有按托主的意愿完成。\n"
        "79、因公恃势乞索、巧索，取人一切财物\n"
        "假公济私，恃势欺人，明目张胆地勒索，或巧取豪夺他人的财宝金银等物品。\n"
        "80、废坏三宝尊像以及殿宇、器用等物\n"
        "废弃毁坏佛菩萨圣像，及安置佛像佛经僧众的三宝殿堂楼阁、佛事法会中所用的法器等物。\n"
        "81、斗秤等小出大入\n"
        "从事于买卖行业，卖出物品时用小称砣，买进货物时用大称砣，短斤缺两，欺诈顾客。\n"
        "82、贩卖屠刀、渔网等物\n"
        "买卖经营屠宰动物的刀具，及捕捞鱼虾龟鳖等水族所用的渔网等物品或其他用于杀生之工具。\n"
        "（全文完）";

@implementation BaihuaViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view = [[FullPageTextView alloc] initWithFrame:self.view.frame content:baihuaContent];
}


@end