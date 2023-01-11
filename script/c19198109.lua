--只因之黑 小黑子蒸虾头
local m = 19198109
local cm = _G["c"..m]
function cm.initial_effect(c)
    --Activaete
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--送墓
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,m)
	e2:SetCost(cm.tgcost)
	e2:SetTarget(cm.tgtg)
	e2:SetOperation(cm.tgop)
	c:RegisterEffect(e2)
	--战阶封锁效果
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetCondition(cm.discon)
	e3:SetOperation(cm.disop)
	c:RegisterEffect(e3)
end
--送墓
function cm.cfilter(c)
	return c:IsSetCard(0x414) and c:IsAbleToHandAsCost()
end
function cm.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil) end
   local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SendtoHand(g,nil,REASON_COST)
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToGrave() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
	Debug.Message("小黑子你食不食油饼，苏珊，蒸虾头")
end
--战阶封锁效果
function cm.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x414)
end
function cm.discon(e)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(cm.filter,c:GetControler(),LOCATION_MZONE,0,3,nil)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	if (re:IsActiveType(TYPE_MONSTER) or re:IsActiveType(TYPE_TRAP) or re:IsActiveType(TYPE_SPELL)) and rp==1-tp and ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE then
		Duel.NegateEffect(ev)
	end
end