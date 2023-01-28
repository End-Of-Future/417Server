--镚壞-圱華
local m=91480007
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.pspcon)
	e1:SetTarget(cm.psptg)
	e1:SetOperation(cm.pspop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,m+1)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY+CATEGORY_DECKDES)
	e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetTarget(cm.dtg)
	e4:SetOperation(cm.dop)
	c:RegisterEffect(e4)
end
function cm.pspfilter(c,tp)
	return c:IsSetCard(0x1551) and c:IsType(TYPE_MONSTER) and c:IsControler(tp)
	and ((c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP)) or c:IsPreviousLocation(LOCATION_HAND))
end
function cm.pspcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:Filter(cm.pspfilter,nil,tp):GetCount()>=1
end
function cm.psptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,LOCATION_PZONE)
	Duel.SetTargetCard(c)
end
function cm.pspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummonStep(c,SUMMON_TYPE_SPECIAL,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		e1:SetRange(LOCATION_MZONE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(1)
		c:RegisterEffect(e1)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
		e3:SetValue(cm.fuslimit)
		c:RegisterEffect(e3)
		local e5=e1:Clone()
		e5:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
		c:RegisterEffect(e5)
		local e6=e1:Clone()
		e6:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		c:RegisterEffect(e6)
	end
	Duel.SpecialSummonComplete()
end
function cm.fuslimit(e,c,st)
	return st==SUMMON_TYPE_FUSION
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0x1551) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if tc then
		Duel.SpecialSummon(tc,SUMMON_TYPE_SPECIAL,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function cm.dfilter(c)
	return c:IsSetCard(0x1550)
end
function cm.dtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetDecktopGroup(tp,1):GetCount()>0 and Duel.GetDecktopGroup(1-tp,1):GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY+CATEGORY_DECKDES,Duel.GetDecktopGroup(tp,1),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY+CATEGORY_DECKDES,Duel.GetDecktopGroup(1-tp,1),1,0,0)
end
function cm.dop(e,tp,eg,ep,ev,re,r,rp)
	local tc1=Duel.GetDecktopGroup(tp,1):GetFirst()
	local tc2=Duel.GetDecktopGroup(1-tp,1):GetFirst()
	if tc1 and tc2 then
		local g=Group.__add(tc1,tc2)
		Duel.Destroy(g,REASON_EFFECT)
		local tg=Duel.GetOperatedGroup()
		if tg:Filter(cm.dfilter,nil):GetCount()>=1 then
			local dc1=Duel.GetDecktopGroup(tp,1):GetFirst()
			local dc2=Duel.GetDecktopGroup(1-tp,1):GetFirst()
			local dg=Group.__add(dc1,dc2)
			Duel.Destroy(dg,REASON_EFFECT)
		end
	end
end
