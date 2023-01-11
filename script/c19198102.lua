--只因之佐 希特鸡·阿道坤
local m = 19198102
local cm = _G["c"..m]
local loc_dg=LOCATION_DECK+LOCATION_GRAVE
function cm.initial_effect(c)
    --连锁特招
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.spcon)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetCategory(CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m+100)
	e2:SetCondition(cm.descon)
	e2:SetTarget(cm.destg)
	e2:SetOperation(cm.desop)
	c:RegisterEffect(e2)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetCurrentChain()
	if ct<2 then return end
	local te,p=Duel.GetChainInfo(ct-1,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	return te and te:GetHandler():IsSetCard(0x414) and p==tp and rp==1-tp
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) and Duel.IsExistingMatchingCard(cm.filter2,tp,loc_dg,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,loc_dg)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_SELECT_EFFECT_TARGET)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
	if Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(cm.filter2,tp,loc_dg,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.filter2,tp,loc_dg,0,1,1,nil)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	Duel.SpecialSummonComplete()
	Debug.Message("身为第二次鸡界大战的胜利者，我不能输")
end
function cm.thfilter(c,ec)
    return c:IsSetCard(0x414) and c:IsType(TYPE_MONSTER) and not c:IsCode(m)
end
function cm.filter2(c)
   return c:IsAbleToHand() and c:IsSetCard(0x414) and c:IsType(TYPE_MONSTER) and not c:IsCode(m)
end
--伤计炸卡
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	if ph~=PHASE_DAMAGE or Duel.IsDamageCalculated() then return false end
	local ac=Duel.GetBattleMonster(tp)
	if not (ac and ac:IsFaceup() and ac:IsSetCard(0x414)) then return false end
	local tc=ac:GetBattleTarget()
	e:SetLabelObject(tc)
	return tc and tc:IsControler(1-tp) and tc:IsRelateToBattle()
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetLabelObject()
	if chk==0 then return tc end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc and tc:IsControler(1-tp) and tc:IsRelateToBattle() then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end