--只因之摆 躺平坤叔
local m = 19198108
local cm = _G["c"..m]
local two_loc=LOCATION_MZONE+LOCATION_HAND
function cm.initial_effect(c)
    c:EnableReviveLimit()
    --特殊同调召唤
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(cm.synchrocon)
	e0:SetOperation(cm.synchroop)
	e0:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e0)
	--盖放或特召
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DECKDES+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.con)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	--伤害步骤弹卡
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_START)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,m+100)
	e2:SetCondition(cm.thcon)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
	--本家通天塔
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,m+100)
	e3:SetCondition(cm.con2)
	e3:SetOperation(cm.thop1)
	c:RegisterEffect(e3)
end
--特殊同调召唤
function cm.synchrofilter1(c)
	return c:IsSetCard(0x414) and c:IsAbleToGraveAsCost() and c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_TUNER)
end
function cm.synchrofilter2(c)
	return c:IsSetCard(0x414) and c:IsType(TYPE_TUNER) and c:IsAbleToHandAsCost()
end
function cm.synchrocon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(cm.synchrofilter1,tp,two_loc,0,1,1,nil,ft) and Duel.IsExistingMatchingCard(cm.synchrofilter2,tp,LOCATION_MZONE,0,1,1,nil)
end
function cm.synchroop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
	local g=Duel.SelectMatchingCard(tp,cm.synchrofilter1,tp,two_loc,0,1,1,nil)
	local g1=Duel.SelectMatchingCard(tp,cm.synchrofilter2,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SendtoGrave(g,nil,REASON_MATERIAL+REASON_COST)
	Duel.SendtoHand(g1,nil,REASON_MATERIAL+REASON_COST)
	Debug.Message("Synchro Summon!")
	Debug.Message("只因之摆 躺平坤叔")
	Debug.Message("让他见识见识什么是摆烂鸡哥")
end
--盖放或特招
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsPlayerCanSSet(tp) end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanDiscardDeck(tp,1) then return end
	Duel.ConfirmDecktop(tp,1)
	local tc=Duel.GetDecktopGroup(tp,1):GetFirst()
	Duel.DisableShuffleCheck()
	if tc:GetType(TYPE_TRAP) and Duel.SSet(tp,tc)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
	if tc:GetType()==TYPE_QUICKPLAY and Duel.SSet(tp,tc)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
	if tc:GetType()==TYPE_FIELD then
	Duel.SSet(tp,tc)
	end
	if tc:GetType()==TYPE_SPELL then
	    Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
	if tc:GetType(TYPE_MONSTER) then
	  Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
	Debug.Message("今天不打篮球了，让我寄会")
end
--伤害步骤弹卡
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,19198104)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
	if c:IsRelateToEffect(e) and c:IsFaceup()
		and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		Duel.BreakEffect()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_DEFENSE)
		e1:SetValue(1500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
end
--通天塔后效果
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,19198104)
end
function cm.thop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
	if c:IsFaceup() and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		Duel.BreakEffect()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_DEFENSE)
		e1:SetValue(1500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
end