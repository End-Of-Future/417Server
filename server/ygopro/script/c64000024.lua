--独角兽的迷梦雾
function c64000024.initial_effect(c)
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_QUICK_O) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetHintTiming(0,TIMING_STANDBY_PHASE+TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCountLimit(1,64000028) 
	e1:SetCost(c64000024.cost) 
	e1:SetTarget(c64000024.target) 
	e1:SetOperation(c64000024.activate)
	c:RegisterEffect(e1)

end
function c64000024.cost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return e:GetHandler():IsReleasable() end 
	Duel.Release(e:GetHandler(),REASON_COST) 
end
function c64000024.tgfilter(c)
	return c:IsAbleToGrave()
end
function c64000024.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c64000024.tgfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_EXTRA)
end
function c64000024.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c64000024.tgfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	local tc=g:GetFirst()
	if g:GetCount()>0 and Duel.SelectOption(tp,1103,1102)==0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	else Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
	Duel.BreakEffect()
	if c:IsPreviousLocation(LOCATION_ONFIELD) then
	local d=0
		local a=tc:GetAttack()
		local b=tc:GetDefense()
		if b>a then a=b end
		if a<0 then a=0 end  
		d=a 
	if d>0 then 
		Duel.Recover(tp,d/2,REASON_EFFECT) 
	end end
end